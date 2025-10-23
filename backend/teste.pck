CREATE OR REPLACE PACKAGE RBM_REL_GLOSA_PREVIA
IS
--
  -- Purpose : Template para Pacote de Servico de Dados para Relatorio
  -- Public type declarations
  --
  -- rec_entidade: registro contendo as colunas de retorno para o relatório
  --
type rec_entidade is record ( DESC_SUCURSAL          VARCHAR2(93)
                            , COD_INSPETORIA_TS      NUMBER(15)
                            , DESC_INSPETORIA        VARCHAR2(123)
                            , COD_OPERADORA          VARCHAR2(10)
                            , NOM_OPERADORA          VARCHAR2(50)                            
                            , NUM_REEMBOLSO_ANS      VARCHAR2(20)
                            , NUM_ASSOCIADO          VARCHAR2(25)
                            , NOME_ASSOCIADO         VARCHAR2(120)
                            , COD_MOTIVO_GLOSA       NUMBER(4)
                            , DESC_MOTIVO_GLOSA      VARCHAR2(200)
                            , DT_INCLUSAO_GLOSA      DATE
                            , COD_USUARIO_OCORRENCIA VARCHAR2(20)
                            , DT_LIBERACAO_GLOSA     DATE
                            , COD_USUARIO_LIBERACAO  VARCHAR2(20)
                            , NOME_SITUACAO          VARCHAR2(50)
                            , VAL_GLOSA              NUMBER
                            , DESC_MOTIVO_REEMBOLSO  VARCHAR2(40)
                            , COD_GRUPO_ESTATISTICO  VARCHAR2(3)
                            , NOME_ITEM              VARCHAR2(260)
                            , QTD_INFORMADO          NUMBER(5)
                            , CARATER_ATENDIMENTO    VARCHAR2(8)
                            , DT_INCLUSAO            DATE
                            , DT_ANALISE             DATE
                            , NOME_CONTRATO          VARCHAR2(120)
                            , NUM_CONTRATO           VARCHAR2(17)
                            , NOME_PLANO             VARCHAR2(100)
                            , IND_REGULAMENTADO      VARCHAR2(17)
                            , NOME_TIPO_EMPRESA      VARCHAR2(40)
                            , TABELA                 VARCHAR2(10)
                            , NOME_TIPO_REEMBOLSO    VARCHAR2(40)
                              );
  --
  -- tbl_entidade: Tabela de Memória cujos elementos retornarão na PTF.
  --
  type tbl_entidade is table of rec_entidade ;
  --
  -- Public constant declarations
  -- Public variable declarations: NAO PODE!!!
  -- Public function and procedure declarations
  --
  -- get_dados: ptf( pipelined table function) que deve obrigatóriamente existir e manter este nome
  --            exceto quanto tiver várias numa só package.
  --
  function get_dados( p_num_seq_fila   number               -- Identificador do serviço solicitado em ts.fila_relatório
                    , p_xml_parametros clob     default null  -- XML com os parametros pertinentes para execução do relatório.
                    )
  return   tbl_entidade
  pipelined
  --
--
--parallel_enable ... ( verificar clausula e necessidade de uso, possibilitando paralelismo quando solicitado na query com hint)
--
  ;
  procedure gera_arquivo(  p_cod_retorno         out varchar2
                         , p_msg_retorno         out varchar2
                         , p_nome_arquivo        out varchar2
                         , p_cod_inspetoria_ts   in  varchar2
                         , p_cod_operadora       in  varchar2
                         , p_ind_tipo_inspetoria in  varchar2
                         , p_dt_ini              in  varchar2
                         , p_dt_fim              in  varchar2
                         , p_ind_situacao        in  number
                         , p_cod_origem          in  number
                         , p_ind_tipo_reembolso  in  varchar2
                         , p_num_associado       in  varchar2
                         , p_cod_motivo_glosa    in number
                         , p_grava_log           in  varchar2 default 'N'
                        );
  --
  function p_versao           return varchar2;
  function p_template_versao  return varchar2;
end;
/
CREATE OR REPLACE PACKAGE BODY RBM_REL_GLOSA_PREVIA
IS
     --
    ----------------------------------------------------------------------------
    -- Rotina usada para gravação e validação da regra de autorização
    ----------------------------------------------------------------------------
  function p_versao   return varchar2
  is
  begin
     return 'CVS>> SPEC: 1.4 - BODY: 1.12';
  end;
  --
  -- Inicilização dos atributos do record de parametros
  -- Também pode ser colocado operações iniciais aqui dentro.
  --
  procedure inicializar( p_tbl_paramSet  in out nocopy top_utl_param.tbl_paramSet
                       , p_rec_controles in out nocopy top_utl_rel.rec_controles
                       , p_xml_param     in            clob
                       )
  is
  begin
     --
     p_rec_controles.logs            := null;
     p_rec_controles.parametros      := p_xml_param;
     --
     p_rec_controles.validacao_ok    := true;
     p_rec_controles.exe_cursor      := false;
     p_rec_controles.chkpoint        := 0;
     p_rec_controles.linhas_lidas    := 0;
     p_rec_controles.linhas_emitidas := 0;
     p_rec_controles.sql_cursor      := null;
     --
     top_utl_param.add_param( p_tbl_paramSet    => p_tbl_paramSet
                            , p_nom_grp_param   => 'parametros'
                            , p_nom_coluna      => 'p_cod_inspetoria_ts'
                            , p_tpo_oracle      => 'VARCHAR2'
                            , p_ind_obrigatorio => 'N'
                            , p_ind_situacao    => '1'
                            , p_nom_label       => 'Código da Inspetoria'
                            , p_tam_maximo      => 200
                            , p_fmt_data        => NULL
                            , p_ind_origem_vlr  => 'N'
                            ) ;
     --
     top_utl_param.add_param( p_tbl_paramSet    => p_tbl_paramSet
                            , p_nom_grp_param   => 'parametros'
                            , p_nom_coluna      => 'p_cod_operadora'
                            , p_tpo_oracle      => 'VARCHAR2'
                            , p_ind_obrigatorio => 'N'
                            , p_ind_situacao    => '1'
                            , p_nom_label       => 'Código da Operadora'
                            , p_tam_maximo      => 200
                            , p_fmt_data        => NULL
                            , p_ind_origem_vlr  => 'N'
                            ) ;
     --
     top_utl_param.add_param( p_tbl_paramSet    => p_tbl_paramSet
                            , p_nom_grp_param   => 'parametros'
                            , p_nom_coluna      => 'p_ind_tipo_inspetoria'
                            , p_tpo_oracle      => 'VARCHAR2'
                            , p_ind_obrigatorio => 'S'
                            , p_ind_situacao    => '1'
                            , p_nom_label       => 'Verifica se Inspetoria é a do Contrato (C) ou da Abertura (A)'
                            , p_tam_maximo      => 1
                            , p_fmt_data        => NULL
                            , p_ind_origem_vlr  => 'N'
                            ) ;
     --
     top_utl_param.add_param( p_tbl_paramSet    => p_tbl_paramSet
                            , p_nom_grp_param   => 'parametros'
                            , p_nom_coluna      => 'p_tipo_data'
                            , p_tpo_oracle      => 'VARCHAR2'
                            , p_ind_obrigatorio => 'N'
                            , p_ind_situacao    => '1'
                            , p_nom_label       => 'Tipo de data'
                            , p_tam_maximo      => 1
                            , p_fmt_data        => NULL
                            , p_ind_origem_vlr  => 'N'
                            ) ;
     --
     top_utl_param.add_param( p_tbl_paramSet    => p_tbl_paramSet
                            , p_nom_grp_param   => 'parametros'
                            , p_nom_coluna      => 'p_dt_ini'
                            , p_tpo_oracle      => 'VARCHAR2'
                            , p_ind_obrigatorio => 'S'
                            , p_ind_situacao    => '1'
                            , p_nom_label       => 'Data Inicial de Solicitação/Pagamento'
                            , p_tam_maximo      => 10
                            , p_fmt_data        => NULL
                            , p_ind_origem_vlr  => 'N'
                            ) ;
     --
     top_utl_param.add_param( p_tbl_paramSet    => p_tbl_paramSet
                            , p_nom_grp_param   => 'parametros'
                            , p_nom_coluna      => 'p_dt_fim'
                            , p_tpo_oracle      => 'VARCHAR2'
                            , p_ind_obrigatorio => 'S'
                            , p_ind_situacao    => '1'
                            , p_nom_label       => 'Data Final de Solicitação/Pagamento'
                            , p_tam_maximo      => 10
                            , p_fmt_data        => NULL
                            , p_ind_origem_vlr  => 'N'
                            ) ;
     --
     top_utl_param.add_param( p_tbl_paramSet    => p_tbl_paramSet
                            , p_nom_grp_param   => 'parametros'
                            , p_nom_coluna      => 'p_ind_situacao'
                            , p_tpo_oracle      => 'NUMBER'
                            , p_ind_obrigatorio => 'N'
                            , p_ind_situacao    => '1'
                            , p_nom_label       => 'Situação do Reembolso'
                            , p_tam_maximo      => 2
                            , p_fmt_data        => NULL
                            , p_ind_origem_vlr  => 'N'
                            ) ;
                            

     --
     top_utl_param.add_param( p_tbl_paramSet    => p_tbl_paramSet
                            , p_nom_grp_param   => 'parametros'
                            , p_nom_coluna      => 'p_cod_origem'
                            , p_tpo_oracle      => 'NUMBER'
                            , p_ind_obrigatorio => 'N'
                            , p_ind_situacao    => '1'
                            , p_nom_label       => 'Origem do Reembolso'
                            , p_tam_maximo      => 2
                            , p_fmt_data        => NULL
                            , p_ind_origem_vlr  => 'N'
                            ) ;
     --
     -- top_utl_param.add_param( p_tbl_paramSet    => p_tbl_paramSet
     --                       , p_nom_grp_param   => 'parametros'
     --                       , p_nom_coluna      => 'p_sgl_area_abertura'
     --                       , p_tpo_oracle      => 'VARCHAR2'
     --                       , p_ind_obrigatorio => 'N'
     --                       , p_ind_situacao    => '1'
     --                       , p_nom_label       => 'Código da agencia de Abertura'
     --                       , p_tam_maximo      => 30
     --                       , p_fmt_data        => NULL
     --                       , p_ind_origem_vlr  => 'N'
     --                       ) ;
     --
     top_utl_param.add_param( p_tbl_paramSet    => p_tbl_paramSet
                            , p_nom_grp_param   => 'parametros'
                            , p_nom_coluna      => 'p_ind_tipo_reembolso'
                            , p_tpo_oracle      => 'VARCHAR2'
                            , p_ind_obrigatorio => 'N'
                            , p_ind_situacao    => '1'
                            , p_nom_label       => 'Tipo Reembolso'
                            , p_tam_maximo      => 2
                            , p_fmt_data        => NULL
                            , p_ind_origem_vlr  => 'N'
                            ) ;
     --
     top_utl_param.add_param( p_tbl_paramSet    => p_tbl_paramSet
                            , p_nom_grp_param   => 'parametros'
                            , p_nom_coluna      => 'p_grava_log'
                            , p_tpo_oracle      => 'VARCHAR2'
                            , p_ind_obrigatorio => 'N'
                            , p_ind_situacao    => '1'
                            , p_nom_label       => 'Grava Log'
                            , p_tam_maximo      => 1
                            , p_fmt_data        => NULL
                            , p_ind_origem_vlr  => 'N'
                            ) ;

     top_utl_param.add_param( p_tbl_paramSet    => p_tbl_paramSet
                            , p_nom_grp_param   => 'parametros'
                            , p_nom_coluna      => 'p_num_associado'
                            , p_tpo_oracle      => 'VARCHAR2'
                            , p_ind_obrigatorio => 'N'
                            , p_ind_situacao    => '1'
                            , p_nom_label       => 'Código Grupo'
                            , p_tam_maximo      => 20
                            , p_fmt_data        => NULL
                            , p_ind_origem_vlr  => 'N'
                            ) ;
                                 --
     top_utl_param.add_param( p_tbl_paramSet    => p_tbl_paramSet
                            , p_nom_grp_param   => 'parametros'
                            , p_nom_coluna      => 'p_cod_motivo_glosa'
                            , p_tpo_oracle      => 'NUMBER'
                            , p_ind_obrigatorio => 'N'
                            , p_ind_situacao    => '1'
                            , p_nom_label       => 'Glosas'
                            , p_tam_maximo      => 5
                            , p_fmt_data        => NULL
                            , p_ind_origem_vlr  => 'N'
                            ) ;
     --
  end;
  --
  -- get_configurações:
  -- -----------------
  -- Obtém informações gerais pertinentes à execução deste relatório
  -- em ts.fila_relatorio, caso tenha a necessidade de outras informações
  -- em top_utl_rel.rec_config_relatorio, falar com os arquitetos.
  --
  procedure get_configuracoes ( p_rec_controles  in out nocopy top_utl_rel.rec_controles
                              , p_reg_config     in out nocopy top_utl_rel.rec_config_relatorio
                              , p_num_seq_fila   in            number
                              )
  is
  begin
     --
     p_reg_config := ts.top_utl_rel.get_configuracoes( p_num_seq_fila => p_num_seq_fila );
     --
     top_utl_rel.abrir_xml_configuracao ( p_xml_log => p_rec_controles.logs );
     top_utl_rel.obter_xml_configuracoes( p_xml_log => p_rec_controles.logs , p_reg_config => p_reg_config );
     --
     if  p_num_seq_fila is null then
         --
         top_utl_rel.abrir_xml_mensagens  ( p_xml_log => p_rec_controles.logs );
         top_utl_rel.gerar_xml_mensagem   ( p_xml_log => p_rec_controles.logs , p_leitor => top_utl_padrao.tpo_leitor_usuario , p_tipo => top_utl_padrao.tpo_mensagem_erro , p_texto => 'O provedor dos dados nao recebeu o identificador do servico de relatorio solicitado.' );
         top_utl_rel.gerar_xml_mensagem   ( p_xml_log => p_rec_controles.logs , p_leitor => top_utl_padrao.tpo_leitor_sistema , p_tipo => top_utl_padrao.tpo_mensagem_erro , p_texto => 'JasperReport: TsCtm1076JR.jasper nao esta enviando o parametro p_num_seq_fila para TableFunction: ctm_rel_valores_liberados.get_dados.' );
         top_utl_rel.fechar_xml_mensagens ( p_xml_log => p_rec_controles.logs );
         --
     end if;
     --
     top_utl_rel.fechar_xml_configuracao( p_xml_log => p_rec_controles.logs );
     --
  end;
  --
  -- tratar_parametros:
  -- -------------------
  --
  procedure tratar_parametros  ( p_rec_controles  in out nocopy top_utl_rel.rec_controles
                               , p_tbl_paramSet   in out nocopy top_utl_param.tbl_paramSet
                               )
  is                                               -- Explique as variaveis
     vlr_maior_sem_menor  number;                  -- Exemplo
     ifld                 varchar2(32);            -- Indice do Parametro
     iPs                  varchar2(32);            -- Indice do Grupo de Parametros
     iRs                  number;                  -- Indice da Ocorrencia
  begin
     --
     top_utl_param.transformar_xml ( p_cod_retorno  => p_rec_controles.ind_retorno
                                   , p_msg_retorno  => p_rec_controles.msg_retorno
                                   , p_xml          => p_rec_controles.parametros
                                   , p_tbl_paramSet => p_tbl_paramSet
                                   ) ;
     --
     if  p_rec_controles.ind_retorno  = top_utl_padrao.tpo_mensagem_informativa then p_rec_controles.validacao_ok := true;
                                                                                else p_rec_controles.validacao_ok := false;
     end if;
     --
     -- Gerando os Logs de conversão e validação dos parametros.
     --
     top_utl_param.gerar_logs      ( p_xml_log       => p_rec_controles.logs
                                   , p_tab_paramsets => p_tbl_paramSet
                                   ) ;

     --
          ts.ts_log_execucao('RBM_REL_GLOSA_PREVIA'
                               , 1
                               , 'log1 nulo'
                               , p_rec_controles.logs
                               , to_char(sysdate)
                              );


     --
  end;
  --
  -- definir_cursor:
  -- ---------------
  -- Montagem do String para execução dinâmica do cursor
  --
  -- O que não pode ser feito de forma alguma é concatenação de parametros,
  -- não importa o tamanho que este método poderá ter.
  --
  procedure definir_cursor      ( p_rec_controles  in out nocopy top_utl_rel.rec_controles
                                , p_info_relatorio in out nocopy top_utl_rel.rec_config_relatorio
                                , p_tbl_paramSet   in out nocopy top_utl_param.tbl_paramSet
                                )
  is
    sTexto               varchar2(32767);
    sFiltro              varchar2(32767);
    v_campo_data         varchar2(50);
    v_cod_inspetoria_ts  varchar2(50);
  begin
     --
     if  p_info_relatorio.qry_padrao is not null then  -- Exemplo de utilização das configurações.
         --
         p_rec_controles.sql_cursor := p_info_relatorio.qry_padrao;
     else
         --
         --
         -- Atribuir a variável abaixo a query compactada, pois atualmente no 10g temos um limite de 32KB
         --
           v_campo_data:= 'dt_inclusao';
         --Determina Se inspetoria é a do contrato ou da abertura
         if p_tbl_paramSet('parametros' ).param('p_ind_tipo_inspetoria').ocorrencia( 1 ).valor_string = 'C' then
            v_cod_inspetoria_ts:= 'cod_inspetoria_ts_contrato';
         else
            v_cod_inspetoria_ts:= 'cod_inspetoria_ts_abertura';
         end if;
         --
         p_rec_controles.sql_cursor :=  trim(' with /*RBM_REL_GLOSA_PREVIA*/                                                                                                                                                      ')
                              || ' ' || trim('        ope as (select /*+materialize cardinality(ope 1)*/ column_value   col                                                                           ')
                              || ' ' || trim('                from   table( cast( top_utl_padrao.split(:p_cod_operadora, '','' ) as ts.lst_varchar_4k ) )                                      ')
                              || ' ' || trim('                union all select o.cod_operadora from ts.operadora o where :p_cod_operadora is null or :p_cod_operadora = ''''),                   ')
                              || ' ' || trim('        par_ope                                                                                                                                         ')
                              || ' ' || trim('            as (select /*+materialize cardinality(p 1)*/ o.cod_operadora , o.nom_operadora                                                              ')
                              || ' ' || trim('                from   ts.operadora o                                                                                                                   ')
                              || ' ' || trim('                     , ope          p                                                                                                                   ')
                              || ' ' || trim('                where  o.cod_operadora = p.col                                                                                                          ')
                              || ' ' || trim('               ) ,                                                                                                                                      ')
                              || ' ' || trim('        par as ( select /*+materialize cardinality(i,1) cardinality(s,1)*/                                                                              ')
                              || ' ' || trim('                        i.cod_sucursal     , s.cod_sucursal     ||'' - ''||s.nome_sucursal   desc_sucursal                                              ')
                              || ' ' || trim('                      , i.cod_inspetoria_ts, i.cod_inspetoria_ts||'' - ''||i.nome_inspetoria desc_inspetoria                                            ')
                              || ' ' || trim('                  from ts.sucursal   s                                                                                                                  ')
                              || ' ' || trim('                     , ts.inspetoria i                                                                                                                  ')
                              || ' ' || trim('                  where s.cod_sucursal      = i.cod_sucursal                                                                                            ')
                              || ' ' || trim('                                    and (:p_cod_inspetoria_ts is null or :p_cod_inspetoria_ts = ''''                                                                      ')
                              || ' ' || trim('                                          or   i.cod_inspetoria_ts in (select /*+cardinality(u,1)*/ to_number(u.column_value)                                                  ')
                              || ' ' || trim('                                                from table(cast(top_utl_padrao.split(:p_cod_inspetoria_ts, '','') as ts.lst_varchar_4k)) u )            ')
                              || ' ' || trim('               )),                                                                                                                                       ')
                              || ' ' || trim(' proc as ( select pre.num_reembolso ,pre.cod_procedimento, im.nome_item, pre.qtd_informado                                                              ')
                              || ' ' || trim('                , pre.val_informado_para_reembolso,pre.val_reembolsado, pre.cod_grupo_estatistico                                                       ')
                              || ' ' || trim('                , pre.val_glosa, pre.num_seq_item                                                                                                                                   ')
                              || ' ' || trim('                   from ts.procedimento_reembolso_previa pre                                                                                            ')
                              || ' ' || trim('                      , ts.itens_medicos im                                                                                                             ')
                              || ' ' || trim('                  where pre.cod_procedimento = im.item_medico) ,                                                                                        ')
                              || ' ' || trim('       usu_glosa as (  select rg.num_reembolso, rg.num_seq_item,rg.dt_inclusao AS dt_inclusao_glosa ,rg.dt_liberacao AS dt_liberacao_glosa, rg.cod_usuario_liberacao, rg.cod_motivo_glosa , mg.desc_motivo_glosa                                               ')
                              || ' ' || trim('                        from ts.reembolso_previa_glosa rg, ts.motivo_glosa mg                                                                                                       ')
                              || ' ' || trim('                       where rg.cod_motivo_glosa = mg.cod_motivo_glosa                                                                                                              ')
                              || ' ' || trim('                       and rg.cod_motivo_glosa = nvl(:p_cod_motivo_glosa, rg.cod_motivo_glosa)                                                                                                              ')
                              || ' ' || trim('                    )                                                                                                                                   ')
                              || ' ' || trim('  select distinct par.desc_sucursal                                                                                                                                                 ')
                              || ' ' || trim('      , pr.'||v_cod_inspetoria_ts||'   as cod_inspetoria_ts                                                                                           ')
                              || ' ' || trim('       , par.desc_inspetoria                                                                                                                            ')
                              || ' ' || trim('       , par_ope.cod_operadora                                                                                                                          ')
                              || ' ' || trim('       , par_ope.nom_operadora                                                                                                                          ')
                              || ' ' || trim('       , pr.num_reembolso_ans                                                                                                                           ')
                              || ' ' || trim('       , pr.num_associado                                                                                                                               ')
                              || ' ' || trim('       , pr.nome_associado                                                                                                                              ')
                              || ' ' || trim('      , usu_glosa.cod_motivo_glosa                                                                                                                                                   ')                                                            
                              || ' ' || trim('      , usu_glosa.desc_motivo_glosa                                                                                                                                                  ')
                              || ' ' || trim('      , usu_glosa.dt_liberacao_glosa                                                                                                                                                   ')
                              || ' ' || trim('         ,(select cod_usuario                                                                                                                           ')
                              || ' ' || trim('             from (                                                                                                                                     ')
                              || ' ' || trim('                   select cod_usuario from ts.reembolso_previa_ocorrencia                                                                               ')
                              || ' ' || trim('                    where cod_tipo_ocorrencia = 2    and num_reembolso = pr.num_reembolso                                                               ')
                              || ' ' || trim('                    order by dt_ocorrencia desc                                                                                                         ')
                              || ' ' || trim('                  )                                                                                                                                     ')
                              || ' ' || trim('            where rownum = 1) as cod_usuario_ocorrencia                                                                                                 ')
                              || ' ' || trim('      , usu_glosa.dt_inclusao_glosa                                                                                                                                                   ')
                              || ' ' || trim('         , usu_glosa.cod_usuario_liberacao                                                                                                              ')
                              || ' ' || trim('         , rps.nome_situacao                                                                                                              ')
                              || ' ' || trim('      , nvl(proc.val_glosa,0)  as val_glosa                                                                                                                                          ')
                              || ' ' || trim('      , mr.desc_motivo_reembolso                                                                                                                                                     ')
                              || ' ' || trim('      , proc.cod_grupo_estatistico                                                                                                                                                   ')
                              || ' ' || trim('      , proc.nome_item                                                                                                                                                               ')
                              || ' ' || trim('      , proc.qtd_informado                                                                                                                                                           ')
                              || ' ' || trim('      , CASE pr.ind_carater                                                                                                                                                          ')
                              || ' ' || trim('             WHEN ''E'' THEN ''ELETIVO''                                                                                                                                             ')
                              || ' ' || trim('             WHEN ''U'' THEN ''URGENCIA''                                                                                                                                              ')
                              || ' ' || trim('             ELSE ''''                                                                                                                                                               ')
                              || ' ' || trim('        END AS carater_atendimento                                                                                                                                                   ')
                              || ' ' || trim('     , pr.dt_inclusao                                                                                                                                                                ')
                              || ' ' || trim('     , case pr.ind_situacao                                                                                                                                                          ')
                              || ' ' || trim('           when  2 then pr.dt_deferimento                                                                                                                                            ')
                              || ' ' || trim('           when  3 then pr.dt_cancelamento                                                                                                                                           ')
                              || ' ' || trim('           when  4 then pr.dt_indeferimento                                                                                                                                          ')
                              || ' ' || trim('           else null                                                                                                                                                                 ')
                              || ' ' || trim('           end as dt_analise                                                                                                                                                                 ')
                              || ' ' || trim('     , pr.nome_contrato                                                                                                                                                              ')
                              || ' ' || trim('     , pr.num_contrato                                                                                                                                                               ')
                              || ' ' || trim('       , pm.nome_plano                                                                                                                                  ')
                              || ' ' || trim('       , decode (pr.ind_regulamentado,''S'',''Regulamentado'',''Não Regulamentado'') ind_regulamentado                                                  ')
                              || ' ' || trim('     , (select re.nome_tipo_empresa                                                                                                                                                  ')
                              || ' ' || trim('          from ts.regra_empresa re                                                                                                                                                   ')
                              || ' ' || trim('             , ts.contrato_empresa ce                                                                                                                                                ')
                              || ' ' || trim('          where ce.tipo_empresa = re.tipo_empresa                                                                                                                                    ')
                              || ' ' || trim('            and ce.num_contrato = pr.num_contrato) as nome_tipo_empresa                                                                                                              ')
                              || ' ' || trim('     , ( select mpd.sigla_tabela_calc from ts.memoria_previa_detalhe mpd where mpd.num_reembolso = pr.num_reembolso and mpd.num_seq_item = proc.num_seq_item) as tabela              ')
                              || ' ' || trim('     , tr.nome_tipo_reembolso                                                                                                                                 ')
                              || ' ' || trim('    from ts.pedido_reembolso_previa        pr                                                                                                           ')
                              || ' ' || trim('       , ts.motivo_reembolso               mr                                                                                                           ')
                              || ' ' || trim('       , ts.plano_medico       pm                                                                                                                       ')
                              || ' ' || trim('       , ts.reembolso_previa_situacao       rps                                                                                                                       ')
                              || ' ' || trim('       , par_ope                                                                                                                                        ')
                              || ' ' || trim('       , par                                                                                                                                            ')
                              || ' ' || trim('       , proc                                                                                                                                           ')
                              || ' ' || trim('       , usu_glosa                                                                                                                                      ')
                              || ' ' || trim('      , ts.tipo_reembolso     tr                                                                                                                               ')
                              || ' ' || trim('   where pr.cod_motivo_reembolso       = mr.cod_motivo_reembolso                                                                                               ')
                              || ' ' || trim('   and pr.ind_situacao = rps.ind_situacao                                                                                               ')
                              || ' ' || trim('    and   pr.cod_plano                  = pm.cod_plano                                                                                                  ')
                              || ' ' || trim('    and   pr.cod_inspetoria_ts_contrato  = par.cod_inspetoria_ts                                                                                        ')
                              || ' ' || trim('    and   pr.cod_operadora_contrato     = par_ope.cod_operadora                                                                                         ')
                              || ' ' || trim('    and   pr.num_reembolso              = proc.num_reembolso(+)                                                                                         ')
                              || ' ' || trim('   and   pr.num_reembolso              = usu_glosa.num_reembolso                                                                                       ')
                              || ' ' || trim('   and   usu_glosa.num_seq_item        = proc.num_seq_item(+)                                                                                           ')
                              || ' ' || trim('    and   pr.'||v_campo_data||'         between :p_dt_ini and :p_dt_fim                                                                                        ')
                              || ' ' || trim('   and   pr.ind_situacao               = nvl(:p_ind_situacao, pr.ind_situacao)                                                                                 ')
                              || ' ' || trim('    and   pr.cod_origem                 = nvl(:p_cod_origem, pr.cod_origem)                                                                             ')
                              || ' ' || trim('    and   pr.ind_tipo_reembolso         = nvl(:p_ind_tipo_reembolso, pr.ind_tipo_reembolso)                                                             ')
                              || ' ' || trim('   and   pr.num_associado              = nvl(:p_num_associado, pr.num_associado)                                                                     ')
                              || ' ' || trim('   and   pr.ind_tipo_reembolso         = tr.ind_tipo_reembolso                                                                                                                           ')
                              || ' ' || trim('group by par.desc_sucursal                                                                                                                                     ')
                              || ' ' || trim('       , pr.'||v_cod_inspetoria_ts||'                                                                                             ')
                              || ' ' || trim('       , par.desc_inspetoria                                                                                                                            ')
                              || ' ' || trim('       , par_ope.cod_operadora                                                                                                                          ')
                              || ' ' || trim('       , par_ope.nom_operadora                                                                                                                          ')
                              || ' ' || trim('       , pr.num_reembolso_ans                                                                                                                           ')
                              || ' ' || trim('       , pr.num_associado                                                                                                                               ')
                              || ' ' || trim('       , pr.nome_associado                                                                                                                              ')
                              || ' ' || trim('       , rps.nome_situacao                                                                                                                              ')
                              || ' ' || trim('      , usu_glosa.cod_motivo_glosa                                                                                                                         ')                                                
                              || ' ' || trim('      , usu_glosa.desc_motivo_glosa                                                                                                                    ')
                              || ' ' || trim('      , usu_glosa.dt_inclusao_glosa                                                                                                                        ')
                              || ' ' || trim('      , usu_glosa.cod_usuario_liberacao                                                                                                                    ')
                              || ' ' || trim('      , usu_glosa.dt_liberacao_glosa                                                                                                                         ')            
                              || ' ' || trim('      , pr.num_reembolso                                                                                                                                   ')
                              || ' ' || trim('      , proc.val_glosa                                                                                                                                     ')
                              || ' ' || trim('      , mr.desc_motivo_reembolso                                                                                                                           ')
                              || ' ' || trim('      , proc.cod_grupo_estatistico                                                                                                                         ')
                              || ' ' || trim('        , proc.nome_item                                                                                                                                ')
                              || ' ' || trim('        , proc.qtd_informado                                                                                                                            ')
                              || ' ' || trim('      , pr.ind_carater                                                                                                                                     ')
                              || ' ' || trim('      , pr.dt_inclusao                                                                                                                                     ')
                              || ' ' || trim('      , pr.dt_sit                                                                                                                                      ')
                              || ' ' || trim('      , pr.nome_contrato                                                                                                                                   ')
                              || ' ' || trim('      , pr.num_contrato                                                                                                                                    ')
                              || ' ' || trim('      , pm.cod_plano                                                                                                                                       ')
                              || ' ' || trim('        , pm.nome_plano                                                                                                                                 ')
                              || ' ' || trim('        , pr.ind_regulamentado                                                                                                                          ')
                              || ' ' || trim('      , proc.num_seq_item                                                                                                                                  ')
                              || ' ' || trim('      , tr.nome_tipo_reembolso                                                                                                                             ')
                              || ' ' || trim('      ,pr.ind_situacao                                                                                                                                     ')
                              || ' ' || trim('      ,pr.dt_deferimento                                                                                                                                   ')
                              || ' ' || trim('      ,pr.dt_cancelamento                                                                                                                                  ')
                              || ' ' || trim('      ,pr.dt_indeferimento                                                                                                                                 ')
                              || ' ' || trim('       order by pr.'||v_cod_inspetoria_ts||'                                                                                                          ')
                              || ' ' || trim('              , pr.num_reembolso_ans                                                                                                                       ')
;
         --
     --    if p_tbl_paramSet('parametros').param('p_grava_log').ocorrencia( 1 ).valor_string = 'S' then
            --
            ts.ts_log_execucao('RBM_REL_GLOSA_PREVIA'
                               , 1
                               , 'SQL'
                               , p_rec_controles.sql_cursor || chr(13)||'--/'|| chr(13)
                                                            || '-- p_cod_inspetoria_ts: ' || p_tbl_paramSet('parametros').param('p_cod_inspetoria_ts'  ).ocorrencia(1).valor_string || chr(13)
                                                            || '-- p_cod_operadora: '     || p_tbl_paramSet('parametros').param('p_cod_operadora'      ).ocorrencia(1).valor_string || chr(13)
                                                            || '-- p_tipo_data: '         || p_tbl_paramSet('parametros').param('p_tipo_data'          ).ocorrencia(1).valor_string || chr(13)
                                                            || '-- p_dt_ini: '            || p_tbl_paramSet('parametros').param('p_dt_ini'             ).ocorrencia(1).valor_string || chr(13)
                                                            || '-- p_dt_fim: '            || p_tbl_paramSet('parametros').param('p_dt_fim'             ).ocorrencia(1).valor_string || chr(13)
                                                            || '-- p_ind_situacao: '      || p_tbl_paramSet('parametros').param('p_ind_situacao'       ).ocorrencia(1).valor_number || chr(13)
                                                            || '-- p_cod_origem: '        || p_tbl_paramSet('parametros').param('p_cod_origem'         ).ocorrencia(1).valor_number || chr(13)
                                                            || '-- p_cod_motivo_glosa: ' || p_tbl_paramSet('parametros').param('p_cod_motivo_glosa'  ).ocorrencia(1).valor_number || chr(13)
                                                            || '-- p_ind_tipo_reembolso: '|| p_tbl_paramSet('parametros').param('p_ind_tipo_reembolso' ).ocorrencia(1).valor_string || chr(13)
                                                            || '-- p_ind_tipo_inspetoria:'|| p_tbl_paramSet('parametros').param('p_ind_tipo_inspetoria').ocorrencia(1).valor_string || chr(13)
                                                            || '-- p_num_associado:'          || p_tbl_paramSet('parametros').param('p_num_associado').ocorrencia(1).valor_string || chr(13)
                                                            || '--/'
                               , to_char(sysdate)
                              );
            --
       --  end if;
         --
     end if;
     --
     p_rec_controles.exe_cursor := true;
     --
  exception
  when others then
       --
       -- Caso um problema ocorra, atribuir false ao controle e agregar a mensagem do problema no XML
       -- O que pode ser feito especificamente para tipo de leitos ( leigo ou técnico ).
       --
       p_rec_controles.exe_cursor := false;
       p_rec_controles.sql_cursor := null;
       --
       top_utl_rel.gerar_xml_mensagem ( p_xml_log => p_rec_controles.logs
                                      , p_leitor  => top_utl_padrao.tpo_leitor_usuario
                                      , p_tipo    => top_utl_padrao.tpo_mensagem_erro
                                      , p_texto   => 'Cursor não definido, '||top_utl_padrao.MsgErro
                                      ) ;
                                       ts.ts_log_execucao('RBM_REL_GLOSA_PREVIA'
                               , 1
                               , 'erro'
                               , p_rec_controles.sql_cursor || chr(13)||'--/'|| chr(13)
                                                            || '-- p_cod_inspetoria_ts: ' || p_tbl_paramSet('parametros').param('p_cod_inspetoria_ts'  ).ocorrencia(1).valor_string || chr(13)
                                                            || '-- p_cod_operadora: '     || p_tbl_paramSet('parametros').param('p_cod_operadora'      ).ocorrencia(1).valor_string || chr(13)
                                                            || '-- p_tipo_data: '         || p_tbl_paramSet('parametros').param('p_tipo_data'          ).ocorrencia(1).valor_string || chr(13)
                                                            || '-- p_dt_ini: '            || p_tbl_paramSet('parametros').param('p_dt_ini'             ).ocorrencia(1).valor_string || chr(13)
                                                            || '-- p_dt_fim: '            || p_tbl_paramSet('parametros').param('p_dt_fim'             ).ocorrencia(1).valor_string || chr(13)
                                                            || '-- p_ind_situacao: '      || p_tbl_paramSet('parametros').param('p_ind_situacao'       ).ocorrencia(1).valor_number || chr(13)
                                                            || '-- p_cod_origem: '        || p_tbl_paramSet('parametros').param('p_cod_origem'         ).ocorrencia(1).valor_number || chr(13)
                                                            --|| '-- p_sgl_area_abertura: ' || p_tbl_paramSet('parametros').param('p_sgl_area_abertura'  ).ocorrencia(1).valor_string || chr(13)
                                                            || '-- p_ind_tipo_reembolso: '|| p_tbl_paramSet('parametros').param('p_ind_tipo_reembolso' ).ocorrencia(1).valor_string || chr(13)
                                                            || '-- p_ind_tipo_inspetoria:'|| p_tbl_paramSet('parametros').param('p_ind_tipo_inspetoria').ocorrencia(1).valor_string || chr(13)
                                                            || '-- p_num_associado:'          || p_tbl_paramSet('parametros').param('p_num_associado').ocorrencia(1).valor_string || chr(13)
                                                            || '--/'
                               , to_char(sysdate)
                              );
  end;
  --
    -- definir_cursor:
  -- ---------------
  -- Montagem do String para execução dinâmica do cursor
  --
  -- O que não pode ser feito de forma alguma é concatenação de parametros,
  -- não importa o tamanho que este método poderá ter.
  --
  --
  -- abrir_cursor:
  -- ------------
  -- Realizar o OPEN para p_cursor
  -- Utilização da DBMS_SQL apenas no 11g quando será possivel converter em
  -- sys_refcursor.
  --
  -- O que não pode ser feito de forma alguma é concatenação de parametros,
  -- não importa o tamanho que este método poderá ter.
  --
  procedure abrir_cursor        ( p_rec_controles  in out nocopy top_utl_rel.rec_controles
                                , p_info_relatorio in out nocopy top_utl_rel.rec_config_relatorio
                                , p_tbl_paramSet   in out nocopy top_utl_param.tbl_paramSet
                                , p_cur_entidade   in out nocopy sys_refcursor
                                )
  is
    v_dt_ini date;
    v_dt_fim date;
  begin
      --
      -- Testes Obrigatório.
      --
      if  p_cur_entidade%isopen then close p_cur_entidade;
      end if;
      --
      -- Se deu problema em definir_cursor, nada deve ser processado.
      --
      if  p_rec_controles.sql_cursor is null or not p_rec_controles.exe_cursor  then return;
      end if;
      --
      -- Definindo o Controle de Acesso:
      -- (1) Se foi informado pelo XML sCodInspetoriaTs e sCodOperadora devem ser utilizados;
      -- (2) Caso contrário, utilizar as definições do cliente
      --
      --
      -- Definindo como o cursor será executado, mediante variações de parametros e variáveis de configuração
      --
      -- ts.top_utl_padrao.putline(  p_rec_controles.sql_cursor );
      --
        v_dt_ini := to_date(p_tbl_paramSet('parametros' ).param('p_dt_ini'            ).ocorrencia( 1 ).valor_string,'dd/mm/yyyy');
        v_dt_fim := to_date(p_tbl_paramSet('parametros' ).param('p_dt_fim'            ).ocorrencia( 1 ).valor_string,'dd/mm/yyyy')+1;
      --
      open  p_cur_entidade
      for   p_rec_controles.sql_cursor
      using  p_tbl_paramSet('parametros' ).param('p_cod_operadora'     ).ocorrencia( 1 ).valor_string
           , p_tbl_paramSet('parametros' ).param('p_cod_operadora'     ).ocorrencia( 1 ).valor_string
           , p_tbl_paramSet('parametros' ).param('p_cod_operadora'     ).ocorrencia( 1 ).valor_string
           , p_tbl_paramSet('parametros' ).param('p_cod_inspetoria_ts' ).ocorrencia( 1 ).valor_string
           , p_tbl_paramSet('parametros' ).param('p_cod_inspetoria_ts' ).ocorrencia( 1 ).valor_string
           , p_tbl_paramSet('parametros' ).param('p_cod_inspetoria_ts' ).ocorrencia( 1 ).valor_string
           , p_tbl_paramSet('parametros' ).param('p_cod_motivo_glosa' ).ocorrencia( 1 ).valor_number
           , v_dt_ini
           , v_dt_fim
           , p_tbl_paramSet('parametros' ).param('p_ind_situacao'      ).ocorrencia( 1 ).valor_number
           , p_tbl_paramSet('parametros' ).param('p_cod_origem'        ).ocorrencia( 1 ).valor_number
           , p_tbl_paramSet('parametros' ).param('p_ind_tipo_reembolso').ocorrencia( 1 ).valor_string
           , p_tbl_paramSet('parametros' ).param('p_num_associado').ocorrencia( 1 ).valor_string
           ;
      --
      top_utl_rel.gerar_xml_mensagem  ( p_xml_log => p_rec_controles.logs
                                      , p_leitor  => top_utl_padrao.tpo_leitor_usuario
                                      , p_tipo    => top_utl_padrao.tpo_mensagem_informativa
                                      , p_texto   => 'Cursor aberto, consulta executavel. Obtendo registros.'
                                      ) ;
      --
      p_rec_controles.exe_cursor := true;
      --
  exception
  when others then
       --
       -- Caso um problema ocorra, atribuir false ao controle e agregar a mensagem do problema no XML
       -- O que pode ser feito especificamente para tipo de leitos ( leigo ou técnico ).
       --
       p_rec_controles.exe_cursor := false;
       top_utl_rel.gerar_xml_mensagem ( p_xml_log => p_rec_controles.logs
                                      , p_leitor  => top_utl_padrao.tpo_leitor_usuario
                                      , p_tipo    => top_utl_padrao.tpo_mensagem_erro
                                      , p_texto   => 'Cursor não foi aberto, '||top_utl_padrao.MsgErro
                                      ) ;
       --
  end;
  --
  -- Table Function: Retorno dos dados
  --
  function get_dados( p_num_seq_fila   number
                    , p_xml_parametros clob     default null
                    )
  return   tbl_entidade
  pipelined
  is
     tab_entidade                      tbl_entidade;                       -- Coleção de retorno deve estar declarada neste escopo
     reg_config                        top_utl_rel.rec_config_relatorio;   -- Configurações obtidas no cadastro do tipo de relatório
     reg_ctrls                         top_utl_rel.rec_controles;          -- Variáveis de Controles do processo
     cur_entidade                      sys_refcursor;                      -- Cursor retornador dos dados.
     --
     tab_paramSet                      top_utl_param.tbl_paramSet;
     --
  begin
     --
     -- Inicializar as variaveis declaradas acima, método obrigatório por não ser Serially_reuseble.
     --
     inicializar( p_tbl_paramSet   => tab_paramSet
                , p_rec_controles  => reg_ctrls
                , p_xml_param      => p_xml_parametros
                ) ;
     --
     -- abrir log
     --
     top_utl_rel.abrir_xml_log( p_xml_log => reg_ctrls.logs ) ;
     --
     -- obter configurações do servico
     --
     reg_ctrls.chkpoint := 100;
     get_configuracoes ( p_rec_controles => reg_ctrls , p_reg_config => reg_config , p_num_seq_fila => p_num_seq_fila );
     --
     if  p_num_seq_fila is null then
       ts.ts_log_execucao('RBM_REL_GLOSA_PREVIA'
                               , 1
                               , 'Num_seq_fila nulo'
                               , ''
                               , to_char(sysdate)
                              );
       goto fechar_relatorio;
     end if;
     --
     -- Efetuar Tratamento dos parametros recebidos
     --
     if  p_xml_parametros is not null then
         --
         ts.ts_log_execucao('RBM_REL_GLOSA_PREVIA'
                               , 1
                               , 'p_xml_parametros nao nulo'
                               , p_xml_parametros
                               , to_char(sysdate)
                              );
         reg_ctrls.chkpoint := 500;
         tratar_parametros   ( p_rec_controles => reg_ctrls , p_tbl_paramSet => tab_paramSet );
         --
     end if;
     --
     reg_ctrls.chkpoint := 700;
     --
      ts.ts_log_execucao('RBM_REL_GLOSA_PREVIA'
                               , 1
                               , 'reg_ctrls.validacao_ok'
                               , case reg_ctrls.validacao_ok when false then'nao'else 'sim'end
                               , to_char(sysdate)
                              );
     if  reg_ctrls.validacao_ok then
         --
         top_utl_rel.abrir_xml_execucao( p_xml_log => reg_ctrls.logs );
         --
         -- Tratamento do Cursor a ser executado
         --
         definir_cursor  ( p_rec_controles => reg_ctrls , p_info_relatorio => reg_config , p_tbl_paramSet => tab_paramSet ) ;
         --
         abrir_cursor    ( p_rec_controles => reg_ctrls , p_info_relatorio => reg_config , p_tbl_paramSet => tab_paramSet , p_cur_entidade => cur_entidade ) ;
         --
         if  reg_ctrls.exe_cursor then
             --
             reg_ctrls.chkpoint := 1000;
             --
             -- Leitura do Cursor
             --
             loop
                 fetch cur_entidade bulk collect into tab_entidade limit 500;
                 exit  when tab_entidade.count = 0;
                 --
                 reg_ctrls.linhas_lidas := reg_ctrls.linhas_lidas + tab_entidade.count;
                 --
                 for i in 1..tab_entidade.count loop
                     --
                     -- Aqui vc ainda pode fazer:
                     -- Aplicação de alguma transformação nas informações da tabela de memória
                     -- Algum Filtro que ficaria muito custoso de manter no cursor, condicionando a linha abaixo
                     -- Efetuar alguma modificação no banco para cada linha lida no cursor.
                     -- ********** --> Neste caso pode ser melhor montar um XML e chamar uma Package de Fachada para trasação.
                     --
                     -- Se não tiver condição de filtro retirar esta linha, pois é apenas um exemplo, e manter o contador
                     -- de linhas emitidas.
                     --
                     if  true then
                         pipe row(tab_entidade(i));
                         reg_ctrls.linhas_emitidas := reg_ctrls.linhas_emitidas + 1;
                     else
                         reg_ctrls.linhas_filtradas := reg_ctrls.linhas_filtradas + 1;
                     end if;
                 end loop;
             end loop;
             --
             close cur_entidade;
             --
             top_utl_rel.gerar_xml_mensagem ( p_xml_log => reg_ctrls.logs
                                            , p_leitor  => top_utl_padrao.tpo_leitor_usuario
                                            , p_tipo    => top_utl_padrao.tpo_mensagem_informativa
                                            , p_texto   => 'Cursor fechado, '||reg_ctrls.linhas_lidas   ||' linhas lidas.'
                                            ) ;
             top_utl_rel.gerar_xml_mensagem ( p_xml_log => reg_ctrls.logs
                                            , p_leitor  => top_utl_padrao.tpo_leitor_usuario
                                            , p_tipo    => top_utl_padrao.tpo_mensagem_informativa
                                            , p_texto   => 'Cursor fechado, '||reg_ctrls.linhas_emitidas||' linhas emitidas.'
                                            ) ;
             --
             reg_ctrls.chkpoint := 5000;
             --
         end if;
         --
         top_utl_rel.fechar_xml_execucao( p_xml_log => reg_ctrls.logs );
         --
     end if;
     --
     <<fechar_relatorio>>
     --
     top_utl_rel.fechar_xml_log( p_xml_log => reg_ctrls.logs );
     --
     -- Caso queria, pode mudar a mensagem conclusiva de execução do log
     --
     if     reg_ctrls.chkpoint     < 5000  then
            --
            reg_ctrls.ind_retorno := top_utl_padrao.tpo_mensagem_erro ;
            reg_ctrls.msg_retorno := 'Erro durante a execução, verificar detalhes do log de ocorrência: '||reg_ctrls.msg_retorno ;
            --
     elsif  reg_ctrls.linhas_lidas = ( reg_ctrls.linhas_emitidas + reg_ctrls.linhas_filtradas ) then
            --
            reg_ctrls.ind_retorno := top_utl_padrao.tpo_mensagem_informativa ;
            reg_ctrls.msg_retorno := 'Processado com sucesso.' ;
            --
     else
           reg_ctrls.ind_retorno := top_utl_padrao.tpo_mensagem_erro ;
           reg_ctrls.msg_retorno := 'Processo deve ter parado no meio da leitura, pois não processou todas as linhas lidas. Verificar logs ou investigar o caso.' ;
     end if;
     --
     if reg_ctrls.ind_retorno = top_utl_padrao.tpo_mensagem_erro then
         top_utl_rel.gravar_fila_relatorio_log( p_num_seq_fila => p_num_seq_fila
                                              , p_xml_log      => reg_ctrls.logs
                                              , p_ind_retorno  => reg_ctrls.ind_retorno
                                              , p_msg_retorno  => reg_ctrls.msg_retorno
                                              ) ;
     end if;
     --
     return;
     --
  exception
  when no_data_needed then
       null;
       --
       top_utl_rel.fechar_xml_log( p_xml_log => reg_ctrls.logs );
       --
       return;
       --
  when others then
       if  reg_ctrls.chkpoint < 5000 then
           --
           top_utl_rel.gerar_xml_mensagem ( p_xml_log => reg_ctrls.logs
                                          , p_leitor  => top_utl_padrao.tpo_leitor_usuario
                                          , p_tipo    => top_utl_padrao.tpo_mensagem_informativa
                                          , p_texto   => top_utl_padrao.MsgErro
                                          ) ;
           --
           if    reg_ctrls.chkpoint < 500 then top_utl_rel.fechar_xml_conversao( p_xml_log => reg_ctrls.logs );
           elsif reg_ctrls.chkpoint < 700 then top_utl_rel.fechar_xml_validacao( p_xml_log => reg_ctrls.logs );
                                          else top_utl_rel.fechar_xml_execucao ( p_xml_log => reg_ctrls.logs );
           end   if;
           --
       end if;
       --
       top_utl_rel.fechar_xml_log( p_xml_log => reg_ctrls.logs );
       --
       if  reg_ctrls.chkpoint < 5000 then
           --
           reg_ctrls.ind_retorno := '3' ;
           reg_ctrls.msg_retorno := 'Erro durante a execução, verificar detalhes do log de ocorrência.' ;
           --
           top_utl_rel.gravar_fila_relatorio_log( p_num_seq_fila => p_num_seq_fila
                                                , p_xml_log      => reg_ctrls.logs
                                                , p_ind_retorno  => reg_ctrls.ind_retorno
                                                , p_msg_retorno  => reg_ctrls.msg_retorno
                                                ) ;
       end if;
       --
       return;
  end;
  --
   procedure gera_arquivo(  p_cod_retorno         out varchar2
                         , p_msg_retorno         out varchar2
                         , p_nome_arquivo        out varchar2
                         , p_cod_inspetoria_ts   in  varchar2
                         , p_cod_operadora       in  varchar2
                         , p_ind_tipo_inspetoria in  varchar2
                         , p_dt_ini              in  varchar2
                         , p_dt_fim              in  varchar2
                         , p_ind_situacao        in  number
                         , p_cod_origem          in  number
                         , p_ind_tipo_reembolso  in  varchar2
                         , p_num_associado       in varchar2
                         , p_cod_motivo_glosa    in number
                         , p_grava_log           in  varchar2 default 'N'
                        )
  is
      --
      vPos                         number;
      vLinha                       varchar2(2000);
      vCaminho                     varchar2(100);
      vCaminho_download            varchar2(100);
      v_nome_arquivo               varchar2(50);
      v_operadora                  number:= -1;
      v_inspetoria                 number:= -1;
      v_num_seq_fila               ts.fila_relatorio.num_seq_fila%type;
      --
      v_ArqPag                     UTL_FILE.File_Type;
      --
      v_count                      number:= 0;
      v_nom_operadora              varchar2(50);
      v_nome_inspetoria            varchar2(80);
      v_num_associado              ts.beneficiario.num_associado%type;
      v_nome_associado             ts.beneficiario.nome_associado%type;

      --
      function n_to_char(p_valor in number) return varchar2
      is
      begin
         return trim(to_char(p_valor, '999G999G990D00','NLS_NUMERIC_CHARACTERS = ,.'));
      exception
         when others then
              return p_valor;
      end;
      --
      procedure abre_arquivo
      is
      begin
        v_ArqPag := utl_file.fopen(vCaminho, v_nome_arquivo, 'W');
      exception
        when utl_file.invalid_path then
             p_cod_retorno:= 9;
             p_msg_retorno:= 'ERRO na abertura do arquivo '|| v_nome_arquivo || ' ERRO : UTL_FILE.INVALID_PATH ';
        when utl_file.invalid_mode then
             p_cod_retorno:= 9;
             p_msg_retorno:= 'ERRO na abertura do arquivo '|| v_nome_arquivo || ' ERRO: UTL_FILE.INVALID_MODE ';
        when utl_file.invalid_operation then
             p_cod_retorno:= 9;
             p_msg_retorno:= 'ERRO na abertura do arquivo '|| v_nome_arquivo || 'ERRO: UTL_FILE.INVALID_OPERATION ';
        when utl_file.invalid_filehandle then
             p_cod_retorno:= 9;
             p_msg_retorno:= 'ERRO na abertura do arquivo '|| v_nome_arquivo || 'ERRO: UTL_FILE.INVALID_FILEHANDLE ';
        when utl_file.write_error then
             p_cod_retorno:= 9;
             p_msg_retorno:= 'ERRO na abertura do arquivo '|| v_nome_arquivo || ' ERRO: UTL_FILE.WRITE_ERROR ';
        when others then
             p_cod_retorno:= 9;
             p_msg_retorno:= 'ERRO inesperado na abertura do arquivo: ' || substr(sqlerrm,1,70) || '...';
      end abre_arquivo;
      --
      procedure grava_linha
      is
      begin
        utl_file.put_line(v_ArqPag, vLinha);
      exception
        when utl_file.invalid_path then
             p_cod_retorno := 9;
             p_msg_retorno := 'ERRO na gravação do detalhe do arquivo '|| v_nome_arquivo || ' ERRO : UTL_FILE.INVALID_PATH ';
        when utl_file.invalid_mode then
             p_cod_retorno := 9;
             p_msg_retorno := 'ERRO na gravação do detalhe do arquivo '|| v_nome_arquivo || ' ERRO: UTL_FILE.INVALID_MODE ';
        when utl_file.invalid_operation then
             p_cod_retorno := 9;
             p_msg_retorno := 'ERRO na gravação do detalhe do arquivo '|| v_nome_arquivo || ' ERRO: UTL_FILE.INVALID_OPERATION ';
        when utl_file.invalid_filehandle then
             p_cod_retorno := 9;
             p_msg_retorno := 'ERRO na gravação do detalhe do arquivo '|| v_nome_arquivo || ' ERRO: UTL_FILE.INVALID_FILEHANDLE ';
        when utl_file.write_error then
             p_cod_retorno := 9;
             p_msg_retorno := 'ERRO na gravação do detalhe do arquivo '|| v_nome_arquivo || ' ERRO: UTL_FILE.WRITE_ERROR - ' || top_utl_padrao.msgerro;
        when others then
             p_cod_retorno := 9;
             p_msg_retorno := 'ERRO inesperado gravação do detalhe: ' || substr(sqlerrm,1,70) || '...';
      end grava_linha;
      --
    begin
      --
      p_cod_retorno:= 0;
      p_msg_retorno:= 'Processo OK';
      --
      -->> Obtem Parametros do Sistema
      vPos := 1;
      --
      begin
        select val_parametro
        into vCaminho
        from controle_sistema
        where cod_parametro = 'UTL_FILE_REEMBOLSO';
      exception
        when no_data_found then
             p_cod_retorno:= 1;
             p_msg_retorno:= 'Caminho de gravação indefinido!';
             return;
      end;
      --
      begin
        select val_parametro
        into vCaminho_download
        from controle_sistema
        where cod_parametro = 'WEB_FILE_REEMBOLSO';
      exception
        when no_data_found then
             p_cod_retorno:= 1;
             p_msg_retorno:= 'Caminho de gravação indefinido!';
             return;
      end;
      --
      vPos:= 2;
      --
      v_nome_arquivo:= 'RBM_REL_GLOSA_PREVIA_'|| to_char(sysdate,'ddmmyyyyhhmmss') || '.csv';
      p_nome_arquivo := vCaminho_download || '|' || v_nome_arquivo;
      --
      abre_arquivo;
      --
      if p_cod_retorno <> 0 then
         return;
      end if;
      --

      vLinha:= 'Amil Assistência Médica - Relatório Glosa Prévia';
      grava_linha;
      --
      vLinha := '';
      vPos:= 3;
      --
      v_num_seq_fila := ts.ts_fila_execucao_seq.nextval;
--      select ts.ts_fila_execucao_seq.nextval into v_num_seq_fila from dual;
      --
      for c in( select  *
                from    table ( ts.RBM_REL_GLOSA_PREVIA.get_dados(   v_num_seq_fila
                                                             ,  '<?xml version=''1.0''?>'
                                                             || '<parametros>'
                                                             || '<p_cod_inspetoria_ts>'   || p_cod_inspetoria_ts   || '</p_cod_inspetoria_ts>'
                                                             || '<p_cod_operadora>'       || p_cod_operadora       || '</p_cod_operadora>'
                                                             || '<p_ind_tipo_inspetoria>' || p_ind_tipo_inspetoria || '</p_ind_tipo_inspetoria>'
                                                             || '<p_dt_ini>'              || p_dt_ini              || '</p_dt_ini>'
                                                             || '<p_dt_fim>'              || p_dt_fim              || '</p_dt_fim>'
                                                             || '<p_ind_situacao>'        || p_ind_situacao        || '</p_ind_situacao>'
                                                             || '<p_cod_origem>'          || p_cod_origem          || '</p_cod_origem>'
                                                             || '<p_ind_tipo_reembolso>'  || p_ind_tipo_reembolso  || '</p_ind_tipo_reembolso>'
                                                             || '<p_num_associado>'       || p_num_associado       || '</p_num_associado>'
                                                             || '<p_grava_log>'           || p_grava_log           || '</p_grava_log>'
                                                             || '</parametros>'
                                                             )
                              )
              )
      loop
          --
          vPos:= 5;
          --
          v_count:= v_count + 1;
          --
          if v_count = 1 then
             --
             vLinha:= vLinha || 'Filial;Operadora;Situação Prévia;Modalidade;Numero Prévia;Marca Ótica;Nome do beneficiário;Código da glosa;Descrição da glosa;Data Aplicação Glosa;Usuário de analise;Data Liberação Glosa;Usuário que liberou a glosa;Valor glosado;Motivo de reembolso;Grupo estatístico;Descrição do procedimento;Quantidade solicitada;Tabela utilizada;Caráter;Data Solicitação;Data Análise;Nome Contrato/Empresa;Número Contrato;Plano;Tipo Contrato';
             grava_linha;
             --
          end if;
          --
           vLinha:=  c.DESC_INSPETORIA
          || ';' || c.NOM_OPERADORA
          || ';' || c.NOME_SITUACAO
          || ';' || c.NOME_TIPO_REEMBOLSO
		      || ';' || c.NUM_REEMBOLSO_ANS ||'"'
          || ';' || c.NUM_ASSOCIADO
          || ';' || c.NOME_ASSOCIADO
          || ';' || c.COD_MOTIVO_GLOSA
          || ';' || c.DESC_MOTIVO_GLOSA
          || ';' || c.DT_INCLUSAO_GLOSA 
          || ';' || c.COD_USUARIO_OCORRENCIA
          || ';' || c.DT_LIBERACAO_GLOSA
          || ';' || c.COD_USUARIO_LIBERACAO
          || ';' || c.VAL_GLOSA
          || ';' || c.DESC_MOTIVO_REEMBOLSO
          || ';' || c.COD_GRUPO_ESTATISTICO
          || ';' || c.NOME_ITEM
          || ';' || c.QTD_INFORMADO
          || ';' || c.TABELA
          || ';' || c.CARATER_ATENDIMENTO
          || ';' || c.DT_INCLUSAO
          || ';' || c.DT_ANALISE
          || ';' || c.NOME_CONTRATO
          || ';' || c.NUM_CONTRATO
          || ';' || c.NOME_PLANO
          || ';' || c.IND_REGULAMENTADO;
          --
          grava_linha;
          --
          if p_cod_retorno <> 0 then
             goto fim;
          end if;
          --
      end loop;
      --
      vPos:= 8;
      --
      if v_count = 0 then
         vLinha:= 'Nenhuma informação encontrada para os critérios selecionados!';
         grava_linha;
      end if;
      --
      vPos:= 10;
      --
    <<fim>>

      if utl_file.is_open(v_arqpag) then
         utl_file.fclose(v_arqpag);
      end if;
      --
      vPos:= 15;
      begin
        ts.util_compacta_arquivo(vCaminho, v_nome_arquivo, v_nome_arquivo || '.zip', 1, 'S', p_msg_retorno, p_cod_retorno);
      exception
        when others then
          p_msg_retorno := 'Erro na chamada da procedure de compactação (TS.UTIL_COMPACTA_ARQUIVO): '||top_utl_padrao.msgerro;
      end;
      --
      if p_cod_retorno = 0 then
        p_msg_retorno := 'Arquivo gerado com sucesso.<BR>'||
                       '<a target=blank href=' || vCaminho_download || '\' || v_nome_arquivo || '.zip' || ' title=Clique aqui para abrir o arquivo>' ||
                       v_nome_arquivo || '.zip'  ||
                       '</a>';
      else
         p_msg_retorno:= 'Problemas na execução! Posição: ' || vpos ||' - '||p_msg_retorno;
         p_cod_retorno:= 9;
      end if;
      --
      return;
      --
    exception
      when no_data_found then
           p_msg_retorno:= 'Nenhuma informação foi encontrada!';
           p_cod_retorno:= 9;
           if utl_file.Is_Open(v_ArqPag) then
              utl_file.FClose(v_ArqPag);
           end if;
           --
           return;
           --
      when others then
           p_msg_retorno := 'Problemas na geração do arquivo - pos: ' || vPos || ' - ' || sqlerrm;
           p_cod_retorno := 9;
           if utl_file.Is_Open(v_ArqPag) then
              utl_file.FClose(v_ArqPag);
           end if;
           --
           return;
           --
    end;
 --
  function  p_template_versao  return varchar2
  is
  begin
     return 'CVS>> SPEC: 1.4 - BODY: 1.11';
  end;
end;
/
