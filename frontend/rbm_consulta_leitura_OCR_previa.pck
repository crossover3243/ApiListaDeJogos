CREATE OR REPLACE PACKAGE rbm_consulta_leitura_OCR_previa
is

  
  --
  function get_rs_pedidos_ativos_ocr   ( p_num_reembolso   in     varchar2
                                  , p_cod_retorno        out number
                                  , p_msg_retorno        out varchar2
                                  )
    return sys_refcursor;
 --
  function get_rs_pedidos_reembolso_previa_ocr ( p_num_reembolso   in      varchar2
                                           , p_ind_situacao    in        varchar2
                                           , p_cod_retorno        out number
                                           , p_msg_retorno        out varchar2
                                           )
    return sys_refcursor;
  --
  function p_versao           return varchar2;
  function p_template_versao  return varchar2;


end;
/
CREATE OR REPLACE PACKAGE BODY rbm_consulta_leitura_OCR_previa
is 
  --
  -- Sempre comente O PORQUE OU PARA QUE de uma operacao ou condicao e nao O QUE
  -- Repetindo com palavras a linha de comando, alem de redundande, e inutil para entendimento.
  -- O QUE serve apenas para assinaturas de m todos e utiliza  o de vari veis.
  --
  --
  function p_versao   return varchar2
  is
  begin
     return 'CVS>> SPEC: 1.2 - BODY: 1.10';
  end;
  
  --
  procedure abrir_cursor        ( p_rec_controles  in out nocopy top_utl_rel.rec_controles
                                , p_info_relatorio in out nocopy top_utl_rel.rec_config_relatorio
                                , p_tbl_paramSet   in out nocopy top_utl_param.tbl_paramSet
                                , p_cur_entidade   in out nocopy sys_refcursor
                                )
  is
  begin
      --
      -- Testes Obrigat rio.
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
      -- (2) Caso contr rio, utilizar as defini  es do cliente
      --
      --
      -- Definindo como o cursor ser  executado, mediante varia  es de parametros e vari veis de configura  o
      --
      ts.top_utl_padrao.putline(  p_rec_controles.sql_cursor );
      --
      --
      --
      open  p_cur_entidade
      for   p_rec_controles.sql_cursor
      using p_tbl_paramSet('parametros' ).param('p_ind_reembolso' ).ocorrencia(1).valor_string;
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
       -- O que pode ser feito especificamente para tipo de leitos ( leigo ou t cnico ).
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
  function get_rs_pedidos_ativos_ocr  ( p_num_reembolso   in     varchar2
                                  , p_cod_retorno        out number
                                  , p_msg_retorno        out varchar2
                                  )
    return sys_refcursor
    is
        v_cursor                      sys_refcursor;
    begin
        v_cursor := get_rs_pedidos_reembolso_previa_ocr(
                p_num_reembolso,
                null,
                p_cod_retorno,
                p_msg_retorno
            );
        return v_cursor;
    end;
 

 function get_rs_pedidos_reembolso_previa_ocr ( p_num_reembolso   in      varchar2
                                     , p_ind_situacao         in      varchar2
                                     , p_cod_retorno        out number
                                     , p_msg_retorno        out varchar2
                                     )
    return sys_refcursor
    is
        v_cod_retorno          number;
        v_msg_retorno          varchar2(200);
        c                      sys_refcursor;
        v_sql                  varchar2(3000);
        v_count                number;
        v_tamanho_reembolso    number;
        v_num_reembolso        pedido_reembolso_previa.num_reembolso%type;
    begin

          p_cod_retorno := 0;
          p_msg_retorno := '';
          --
          select length(p_num_reembolso)
          into v_tamanho_reembolso
          from dual;
        --
        if v_tamanho_reembolso > 15 then
          select p.num_reembolso
            into v_num_reembolso
            from ts.pedido_reembolso_previa p
           where p.num_reembolso_ans = p_num_reembolso;
        else
          v_num_reembolso := p_num_reembolso;
        end if;
          --
          select count(*)
            into v_count
            from ts.pedido_reembolso_previa pr
          where  pr.num_reembolso  = v_num_reembolso;

          if v_count = 0 then
             p_cod_retorno := 9;
             p_msg_retorno := 'Prévia não encontrada.';
          end if;

        v_sql :=  trim(' select rpa.dt_anexado                                             ')
              || rtrim(' , rtap.nom_tipo_anexo                                             ')
              || rtrim(' , rpa.nom_arq_anexo                                               ')
              || rtrim(' from pedido_reembolso_previa pr                                   ')
              || rtrim('      ,reembolso_previa_anexo rpa                                  ')
              || rtrim('      ,rbm_tipo_anexo_previa rtap                                  ')
              || rtrim(' where  pr.ind_situacao = nvl(:p_ind_situacao,pr.ind_situacao)     ')
              || rtrim('   and pr.num_reembolso   = :p_num_reembolso                       ')
              || rtrim('   and rpa.num_reembolso   = pr.num_reembolso                      ')
              || rtrim('   and rtap.nom_tipo_anexo = rpa.txt_descricao                     ')
              || rtrim('   and rpa.num_reembolso   = pr.num_reembolso                      ')
              || rtrim(' group by  rpa.nom_arq_anexo ,rpa.dt_anexado, rtap.nom_tipo_anexo  ')
              || rtrim(' order by rpa.dt_anexado desc                                      ')
              ;

             open  c
              for  v_sql
            using  p_ind_situacao, v_num_reembolso;
            --
            return c;

    exception
        when others then
             p_msg_retorno := 'Erro - ' || sqlerrm;
           p_cod_retorno := 9;
            open c
            for select * from dual where 1 = 2;

            return c;

    end;
--


  function  p_template_versao  return varchar2
  is
  begin
     return 'CVS>> SPEC: 1.4 - BODY: 1.11';
  end;
end;
/
