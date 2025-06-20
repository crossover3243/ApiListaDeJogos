
<%@ LANGUAGE="VBSCRIPT" %>
<% 
   '-----------------------------------------------------------
   '-  Prévia de Reembolso
   '-  Autor: TopDown
   '-  Criação: 01/09/2008
   '-  Alterações: 15/09/2022 - Inclusão coluna valor Apresentado - DET
   '-----------------------------------------------------------

   option explicit
   
   dim ind_insc_fiscal_solicitante, nome_prestador_solicitante, num_insc_fiscal_solicitante, num_crm_solicitante, sigla_conselho_solicitante, cod_cbo_solicitante, nome_cbo_solicitante, uf_conselho_solicitante, cnes_solicitante, cod_solicitante
   dim desabilitadoCRTHist, desabilitadoOrigemHist
   dim txt_disabled_hi, bTelaDesabilitada,sWhereAtendimento

   dim txt_usuario, txt_senha, txt_ip, txt_modulo, txt_sistema, txt_msg, txt_disabled, iQtdDias
   dim txt_subtitulo, txt_pgm_retorno, oPesquisa, sDisplayBenef, nome_contrato, sImgErro
   dim ult_num_seq_item, dt_pedido, qtdMaxLength, ind_vincular_enviar, rsCombo, nome_tipo_acomodacao
   dim num_associado, nome_associado, cod_ts,  ind_tipo_acomodacao, cod_tipo_contrato, data_inclusao, data_exclusao
   dim cod_titular_contrato, ind_situacao, ind_sexo, tipo_associado, cod_empresa, cod_dependencia, cod_ts_tit
   dim cod_ts_contrato, tipo_empresa, num_contrato, dt_exclusao, nome_operadora, cod_operadora, cod_marca
   dim nome_plano, cod_plano, data_nascimento, idade_associado, qtd_idade, nom_situacao_associado
   dim txt_observacao, data_atual, ind_tipo_emissao, num_fax, txt_email, i, txt_email_exec, txt_email_local
   dim ind_internado, qtd_procedimento, ind_forma_abertura, num_reembolso, txt_observacao_operadora, idade_associado_exibicao
   dim data_adaptacao, tem_aditivo
   dim nome_situacao, cod_ts_resp, cod_tratamento, cod_acomodacao, dt_inclusao, dt_situacao
   dim ind_insc_fiscal, nome_prestador, num_insc_fiscal, num_crm, uf_conselho, sigla_conselho
   dim val_calculado, val_informado, cod_usuario_pedido, val_reembolsado, val_copart, ind_carater, cnes, cod_cbo,val_apresentado
   dim nome_cbo, dt_indeferimento, dt_analise, cod_entidade_ts_tit, txt_num_fax, txt_ddd_fax, txt_ramal_fax
   dim ind_acomodacao, cod_motivo, ind_tipo, ind_utilizacao, qtd_glosa_analise, qtd_grupo_analise, qtd_glosa_analisada
   dim dt_inclusao_pedido, nome_filial, nom_rede, cod_rede

   dim ddd_residencial, ddd_comercial, ddd_celular, tel_celular, cod_origem, tel_residencial, tel_comercial
   dim ind_tipo_reembolso, cod_inspetoria_ts_abertura, num_cpf, num_cnpj, txt_sexo

   dim xml_pedido, xml_procedimento, xml_ocorrencia, xml_anexo, rsPesquisa, oXML, oRegXML, xml_associado
   dim txt_readonly, disabled, txt_readonly_radio
   dim StrTipoAssociado, bAcessoOperadora, nome_situacao_pedido, sWhereMotivo, cod_motivo_reembolso

   dim ind_visibilidade, xml_permissoes, xml_funcoes
   dim botaoAlterar, botaoCancelar, botaoFinalizar, botaoTranferirGrupo
   dim dias_qtd_prazo_ab, qtd_dias_reembolso, nome_situacao_esp, nome_imagem, nome_motivo
   dim num_seq_itens_proc
   dim num_internacao, dt_provavel_reembolso, qtd_dias_reemb_uteis
   dim cod_acao_ts, dt_ini_vigencia, ind_erro_ws, msg_erro_ws
   dim ind_acesso_cam, cod_usuario_cam, txt_disabled_cam, ind_popup, qtd_familia
   Redim vet_PL(0)
   dim cod_inspetoria_ts, tsUrlChamadaCAM, tipo_pessoa_contrato, ind_origem_associado, ind_consulta
   dim num_titular, nome_titular, nome_contrato_exibicao, tipo_pesquisa_beneficiario, ind_regulamentado, ind_plano_com_reembolso
   dim ind_processo, ind_executando,pgm, txt_pgm_retorno_in, ind_retorno_fila, ind_retorno
   dim dt_comprovante, val_moeda_estrangeira, ind_internacional, sigla_moeda, val_comprovante

   dim rbm_rel_num_reembolso, rbm_rel_envia_email, txt_msg_ocorrencia_email,tipo_finalizacao

   dim ind_retorno_relatorio,num_reembolso_ant,txt_ind_mensagem,ind_forma_exibicao, cod_grupo_empresa,aux_tem_msg,sXMLD
   dim oRegXMLAtendimento,oXMLAtendimento, txt_mensagem
   dim ind_acao_judicial_cliente

   qtd_familia = 0
   sWhereAtendimento = ""
   
   
	
					
    'Barata inicio
    dim strauxurl, exibe_alerta_cadastral
    exibe_alerta_cadastral = request("exibe_alerta_cadastral")
    'Barata fim

   if Request.QueryString("pm") <> "" then
      Session("ace_modulo") = Request.QueryString("pm")
   end if

   txt_usuario = Session("ace_usuario")
   txt_senha   = Session("ace_senha")
   txt_ip      = Session("ace_ip")
   txt_modulo  = Session("ace_modulo")
   txt_sistema = Session("ace_sistema")


   sWhereMotivo = ""
   session("prb_pgm_retorno") = ""

   ind_retorno_relatorio = request("ind_retorno_relatorio")

   if ind_retorno_relatorio = "N" then
      ind_retorno_relatorio = ""
      txt_msg = request("txt_msg")
   else
      txt_msg = Session("txt_msg")
   end if

   Session("txt_msg") = ""
   rbm_rel_num_reembolso = Session("rbm_rel_num_reembolso")
   Session("rbm_rel_num_reembolso") = ""
   rbm_rel_envia_email = Session("rbm_rel_envia_email")
   Session("rbm_rel_envia_email") = ""
   tipo_finalizacao = session("tipo_finalizacao")
   session("tipo_finalizacao") = ""

   txt_subtitulo  = Request.QueryString("PT")
   ind_forma_abertura  = Request("ind_forma_abertura")
   
   	desabilitadoCRTHist = "N"
	desabilitadoOrigemHist ="N"
	
	if ind_forma_abertura = "HI" then
	   desabilitadoCRTHist = "S"
	   desabilitadoOrigemHist = "S"
	end if
	
	if ind_forma_abertura = "HI" or ind_forma_abertura = "DP" then
	    bTelaDesabilitada = true
		txt_disabled_hi = "disabled class=camposblocks"
	else
	    bTelaDesabilitada = false
		txt_disabled_hi = ""
	end if

   ind_acesso_cam  = Request("ind_acesso_cam")
   ind_consulta  = Request("ind_consulta")
   cod_usuario_cam  = Request("cod_usuario_cam")
   num_associado  = Request("num_associado")
   ind_popup        = Request("ind_popup")

   session("pgm_retorno_erro") = ""

   session("pgm_retorno") = Request.ServerVariables("SCRIPT_NAME") & "?pt=" & txt_subtitulo & "&ind_forma_abertura=" & ind_forma_abertura' & "&pgm=" &Request("pgm")
    txt_pgm_retorno        = session("pgm_retorno")
   session("rbm_pgm_retorno") = txt_pgm_retorno

   txt_ind_mensagem = "none"

   if rbm_rel_envia_email = "S" then

      dim tipo_ocorrencia

      if tipo_finalizacao = "A" then
         tipo_ocorrencia     = 3
      else
         tipo_ocorrencia     = 5
      end if

      txt_msg_ocorrencia_email = txt_msg & " Enviada para o e-mail: " & Request("txt_email")

    'rbm_rel_num_reembolso gerar log para esta previa
            Dim vetFuncao(7, 4)

          vetFuncao(1, 1) = "IN"
          vetFuncao(1, 2) = "adDouble"
          vetFuncao(1, 3) = "p_num_reembolso"
         vetFuncao(1, 4) = rbm_rel_num_reembolso

          vetFuncao(2, 1) = "IN"
          vetFuncao(2, 2) = "adDouble"
          vetFuncao(2, 3) = "p_cod_ocorrencia"
         vetFuncao(2, 4) = tipo_ocorrencia

          vetFuncao(3, 1) = "IN"
          vetFuncao(3, 2) = "adVarChar"
          vetFuncao(3, 3) = "p_txt_obs"
         vetFuncao(3, 4) = " "

          vetFuncao(4, 1) = "IN"
          vetFuncao(4, 2) = "adVarChar"
          vetFuncao(4, 3) = "p_txt_operadora"
          vetFuncao(4, 4) = txt_msg_ocorrencia_email


          vetFuncao(5, 1) = "IN"
          vetFuncao(5, 2) = "adVarChar"
          vetFuncao(5, 3) = "p_cod_usuario"
          vetFuncao(5, 4) = session("ace_usuario")

          vetFuncao(6, 1) = "OUT"
          vetFuncao(6, 2) = "adDouble"
          vetFuncao(6, 3) = "p_cod_retorno"

         vetFuncao(7, 1) = "OUT"
          vetFuncao(7, 2) = "adVarChar"
          vetFuncao(7, 3) = "p_msg_retorno"

          Call ExecutaPLOracle(   CStr(session("ace_usuario")),_
                              CStr(session("ace_senha")),_
                              CStr(session("ace_ip")),_
                              CStr(session("ace_sistema")),_
                              CStr(session("ace_modulo")),_
                              "RB_PREVIA_REEMBOLSO.GeraOcorrencia", _
                              vetFuncao, _
                              false )
         FechaConexao()
   end if


   if ind_forma_abertura <> "IN" then
      txt_readonly = "readonly class=camposblocks"
      txt_readonly_radio = "disabled class=camposblocks"
      txt_disabled_cam = "disabled class=camposblocks"
   else
      txt_readonly = ""
      txt_readonly_radio = ""
      txt_disabled_cam = ""
   end if

   if ind_acesso_cam = "S" or txt_modulo = 40 then
      txt_disabled_cam = "disabled class=camposblocks"
      cod_origem = 5
      ind_popup   = "S"
      session("rbm_pgm_retorno") = "../../rbm/asp/rbm1012a.asp?ind_forma_abertura=CO&pt=Histórico Prévia&ind_acesso_cam=S&ind_popup=S"
   end if

   if session("ace_tipo_usuario") = "1" then
        bAcessoOperadora = false
      ind_visibilidade = "E"
    else
      ind_visibilidade = "I"
        bAcessoOperadora = true
    end if


    ind_processo        = Request("ind_processo")
    if ind_processo = "" then
        ind_processo = "N"
    end if

    num_reembolso = Request("num_reembolso")

   ind_executando = Request("ind_executando")

   'recupera dados da tela de situacao
   pgm = Request("pgm")
   if pgm = "" and  ( Request("ind_popup") <> "S" and  Request("botao_voltar") <> "S" ) then
      session("retorno_pgm_sit") = ""

   else
   ' se veio do resultado da pesquisa de situações e caiu em alguma validação, retorna para tela de situações
      if instr(pgm,"rbm1007")>0 and txt_msg <> "" and num_reembolso = "" then
         session("txt_msg") = txt_msg

         response.redirect "../../rbm/asp/" & pgm & "?" & session("retorno_pgm_sit")
      end if
   end if

   'CARREGAR PRÉVIA DE REEMBOLSO ------------------------------------------------------------------------------------
   'num_reembolso = Request("num_reembolso")

   if trim(num_reembolso) <> "" AND ind_forma_abertura <> "IN" then

      '------------------------------------------------
      'Recuperar dados da prévia
      '------------------------------------------------
      Redim vet_PL(4,4)

      vet_PL(1, 1) = "IN"
       vet_PL(1, 2) = "adVarChar"
      vet_PL(1, 3) = "p_num_reembolso"
      vet_PL(1, 4) = num_reembolso

      vet_PL(2, 1) = "OUT"
      vet_PL(2, 2) = "adLongVarChar"
      vet_PL(2, 3) = "p_xml_retorno"

      vet_PL(3, 1) = "IN"
      vet_PL(3, 2) = "adLongVarChar"
      vet_PL(3, 3) = "p_xml_filtro"
      vet_PL(3, 4) = ""

      vet_PL(4, 1) = "IN"
      vet_PL(4, 2) = "adVarChar"
      vet_PL(4, 3) = "p_ind_forma_abertura"
      vet_PL(4, 4) = Request("ind_forma_abertura")
      Call ExecutaPLOracle (   CStr(session("ace_usuario")),_
                          CStr(session("ace_senha")),_
                        CStr(session("ace_ip")),_
                        CStr(session("ace_sistema")),_
                        CStr(session("ace_modulo")),_
                        "RB_PREVIA_REEMBOLSO.RetornaPrevia", _
                        vet_PL, _
                        false )

      FechaConexao()

      xml_pedido = vet_PL(2, 4)

      if trim(xml_pedido) = "" then
          num_reembolso = ""
          txt_msg = "Prévia de reembolso não encontrada"
      end if

      if trim(num_reembolso) <> "" then
          '------------------------------------------------
          'Recuperar dados do procedimento
          '------------------------------------------------
          Redim vet_PL(2,4)

          vet_PL(1, 1) = "IN"
            vet_PL(1, 2) = "adVarChar"
          vet_PL(1, 3) = "p_num_reembolso"
          vet_PL(1, 4) = num_reembolso

          vet_PL(2, 1) = "OUT"
          vet_PL(2, 2) = "adLongVarChar"
          vet_PL(2, 3) = "p_xml_retorno"

          Call ExecutaPLOracle (   CStr(session("ace_usuario")),_
                              CStr(session("ace_senha")),_
                            CStr(session("ace_ip")),_
                            CStr(session("ace_sistema")),_
                            CStr(session("ace_modulo")),_
                            "RB_PREVIA_REEMBOLSO.RetornaItensNova", _
                            vet_PL, _
                            false )

          FechaConexao()

          xml_procedimento = vet_PL(2, 4)

          '------------------------------------------------
          'Recuperar dados da ocorrencia
          '------------------------------------------------
          Redim vet_PL(2,4)

          vet_PL(1, 1) = "IN"
            vet_PL(1, 2) = "adVarChar"
          vet_PL(1, 3) = "p_num_reembolso"
          vet_PL(1, 4) = num_reembolso

          vet_PL(2, 1) = "OUT"
          vet_PL(2, 2) = "adLongVarChar"
          vet_PL(2, 3) = "p_xml_retorno"

          Call ExecutaPLOracle (   CStr(session("ace_usuario")),_
                              CStr(session("ace_senha")),_
                            CStr(session("ace_ip")),_
                            CStr(session("ace_sistema")),_
                            CStr(session("ace_modulo")),_
                            "RB_PREVIA_REEMBOLSO.RetornaOcorrencia", _
                            vet_PL, _
                            false )

          FechaConexao()

          xml_ocorrencia = vet_PL(2, 4)

          '------------------------------------------------
          'Recuperar Anexos
          '------------------------------------------------
          Redim vet_PL(2,4)

          vet_PL(1, 1) = "IN"
            vet_PL(1, 2) = "adVarChar"
          vet_PL(1, 3) = "p_num_reembolso"
          vet_PL(1, 4) = num_reembolso

          vet_PL(2, 1) = "OUT"
          vet_PL(2, 2) = "adLongVarChar"
          vet_PL(2, 3) = "p_xml_retorno"

          Call ExecutaPLOracle (   CStr(session("ace_usuario")),_
                              CStr(session("ace_senha")),_
                            CStr(session("ace_ip")),_
                            CStr(session("ace_sistema")),_
                            CStr(session("ace_modulo")),_
                            "RB_PREVIA_REEMBOLSO.RetornaAnexo", _
                            vet_PL, _
                            false )

          FechaConexao()

          xml_anexo = vet_PL(2, 4)

          '------------------------------------------------
          'Recuperar o último num_seq_item
          '------------------------------------------------
          Redim vet_PL(1,4)

          vet_PL(1, 1) = "IN"
          vet_PL(1, 2) = "adVarChar"
          vet_PL(1, 3) = "p_num_reembolso"
          vet_PL(1, 4) = num_reembolso

          Set rsPesquisa = rsCursorOracle (   CStr(session("ace_usuario")),_
                                       CStr(session("ace_senha")),_
                                     CStr(session("ace_ip")),_
                                     CStr(session("ace_sistema")),_
                                     CStr(session("ace_modulo")),_
                                     "RB_PREVIA_REEMBOLSO.RetornaUltimoSeqItem", _
                                     vet_PL, _
                                     false )
          If Not rsPesquisa.EOF then
             if Not IsNull(rsPesquisa(0)) then
                ult_num_seq_item = rsPesquisa(0)
             end if
          end if
          FechaConexao()

          Set rsPesquisa = Nothing

         '------------------------------------------------------------
         ' Recuperar Permissões do usuário
         '------------------------------------------------------------


         xml_permissoes       = RetornarXMLFuncao()

         botaoAlterar            = PermissaoFuncao("PRV1003.1")
         botaoCancelar         = PermissaoFuncao("PRV1003.2")
         botaoFinalizar         = PermissaoFuncao("PRV1003.3")
         botaoTranferirGrupo   = PermissaoFuncao("PRV1003.4")


      end if
   end if

   %>
   <!--Include do recordset oracle-->
   <!--#include file=..\..\gen\asp\gen0146a.asp-->
   <!--#include file=..\..\gen\asp\gen0146b.asp-->
   <%

    if trim(ult_num_seq_item) = "" then
      ult_num_seq_item = "0"
   end if

   tsUrlChamadaCAM             = RetornaParametro("TS_URL_CHAMADA_CAM", "http://192.168.150.95/cgi-bin/nph-mgwcgi.cgi?NAMESPC=PGM&PRG=^ATDSFSHOW&login=SISAMIL&permi=0")
   tipo_pesquisa_beneficiario   = RetornaParametro("TIPO_PESQUISA_BENEFICIARIO", "G3")


    Function MontaComboEspecialidade (iLinha, iValue)

        Dim rsCombo, strCombo, sRetorno, sWhereMotivo

        sWhereMotivo = " where ind_solicitacao_reembolso = 'S' "

        set rsCombo = retornaCursor("especialidade","cod_especialidade","nome_especialidade",sWhereMotivo, "order by nome_especialidade")

        sRetorno = montaCombo(rsCombo, "cod_especialidade_" & iLinha, iValue, "", "S")

        MontaComboEspecialidade = sRetorno

    End Function

    'Barata inicio
    if request("exibe_alerta_cadastral") = "S" then
        strauxurl = ""
        strauxurl = strauxurl & "&cod_ts=" & request("cod_ts")
        strauxurl = strauxurl & "&cod_ts_tit=" & request("cod_ts_tit")
        strauxurl = strauxurl & "&tipo_associado=" & request("tipo_associado")
        strauxurl = strauxurl & "&num_atendimento_ts=" & request("num_atendimento_ts")
        strauxurl = strauxurl & "&cod_funcao_origem=" & request("cod_funcao_origem")
        strauxurl = strauxurl & "&nome_funcao_origem=" & request("nome_funcao_origem")
        strauxurl = strauxurl & "&ind_tipo_produto=" & request("ind_tipo_produto")
        strauxurl = strauxurl & "&cod_ts_contrato=" & request("cod_ts_contrato")
        strauxurl = strauxurl & "&cod_entidade_ts_tit=" & request("cod_entidade_ts_tit")
        strauxurl = strauxurl & "&cod_plano=" & request("cod_plano")
    end if
    'Barata fim
%>

<HTML>
<HEAD>
<style>
   .msg_grid
   {
      COLOR: #ff0000;
   }
    .grid_center_recusado
    {
        FONT-WEIGHT: bold;
        FONT-SIZE: 8pt;
        COLOR: RED;
        FONT-FAMILY: Verdana;
        BACKGROUND-COLOR: #eeeeee;
        TEXT-ALIGN: center
    }
    .grid_center02_recusado
    {
        FONT-WEIGHT: bold;
        FONT-SIZE: 8pt;
        COLOR: RED;
        FONT-FAMILY: Verdana;
        BACKGROUND-COLOR: lightgrey;
        TEXT-ALIGN: center
    }
    .grid_left_recusado
    {
        FONT-WEIGHT: bold;
        FONT-SIZE: 8pt;
        COLOR: RED;
        FONT-FAMILY: Verdana;
        BACKGROUND-COLOR: #eeeeee;
        TEXT-ALIGN: left
    }
    .grid_left02_recusado
    {
        FONT-WEIGHT: bold;
        FONT-SIZE: 8pt;
        COLOR: RED;
        FONT-FAMILY: Verdana;
        BACKGROUND-COLOR: lightgrey;
        TEXT-ALIGN: left
    }
    .grid_right_recusado
    {
        FONT-WEIGHT: bold;
        FONT-SIZE: 8pt;
        COLOR: RED;
        FONT-FAMILY: Verdana;
        BACKGROUND-COLOR: #eeeeee;
        TEXT-ALIGN: right
    }
    .grid_right02_recusado
    {
        FONT-WEIGHT: bold;
        FONT-SIZE: 8pt;
        COLOR: RED;
        FONT-FAMILY: Verdana;
        BACKGROUND-COLOR: lightgrey;
        TEXT-ALIGN: right
    }
</style>
<link href="\gen\css\css002.css" rel="stylesheet" type="text/css">
<link id="luna-tab-style-sheet" href="\gen\css\tab2.css" rel="stylesheet" type="text/css">
<!--script type="text/javascript" src="\gen\js\tabpane.js"></script-->

<!-- CALENDARIO INICIO -->
<link rel="stylesheet" type="text/css" media="all" href="\gen\css\calendar-green.css" title="green" />
<script type="text/javascript" src="\gen\js\calendar.js"></script>
<script type="text/javascript" src="\gen\js\calendar-br.js"></script>
<script type="text/javascript" src="\gen\js\calendar-setup.js"></script>
<script type="text/javascript" src="\cal\asp\Cal0087.js"></script>

<!-- CALENDARIO FIM -->
<script type="text/javascript" src="../../gen/modal/modal.crossbrowser.min.js"></script>
</HEAD>
<!--#include file=..\..\gen\inc\inc0000.asp-->
<!--#include file=..\..\gen\inc\inc0001.asp-->
<!--#include file=..\..\gen\inc\inc0002.asp-->


<script type="text/javascript" src="../../gen/modal/modal.crossBrowser.min.js"></script>
<script src="../../gen/js/cpaint2.inc.compressed.js" type="text/javascript"></script>
<script src="\gen\js\waitbar.js" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" href="\gen\css\progbar.css">
<script type="text/javascript" src="../../gen/modal/modal.alert.js"></script>

<BODY onload="verMesgIni();ValidaPerfilPrevencaoFraude();">

<%


if trim(xml_pedido) = "" then
   if trim(num_reembolso) <> "" then
      txt_msg = "Prévia de reembolso não encontrada"
      num_reembolso = ""
   else
       if trim(dt_inclusao_pedido) = "" AND ind_forma_abertura = "IN" then
          '------------------------------------------------
          'Recuperar SYSDATE
          '------------------------------------------------
          Redim vet_PL(2,4)

          vet_PL(1, 1) = "IN"
          vet_PL(1, 2) = "adVarchar"
          vet_PL(1, 3) = "p_cod_formato"
          vet_PL(1, 4) = "DD/MM/YYYY"

          vet_PL(2, 1) = "OUT"
          vet_PL(2, 2) = "adVarchar"
          vet_PL(2, 3) = "p_data"

          Call ExecutaPLOracle (   CStr(session("ace_usuario")),_
                              CStr(session("ace_senha")),_
                            CStr(session("ace_ip")),_
                            CStr(session("ace_sistema")),_
                            CStr(session("ace_modulo")),_
                            "RB_PREVIA_REEMBOLSO.RetornaData", _
                            vet_PL, _
                            false )

          FechaConexao()

          dt_inclusao_pedido = vet_PL(2, 4)

       end if
   end if

else
   Set oXML = CreateObject("Microsoft.XMLDOM")
   oXML.async = False
   oXML.loadXML(xml_pedido)
   Set oRegXML = oXML.getElementsByTagName("DADOS")

   if oRegXML.Item(0).selectSingleNode("./COD_RETORNO").Text <> "0" then
      txt_msg = oRegXML.Item(0).selectSingleNode("./MSG_RETORNO").Text
      num_reembolso = ""
   else

      'Validar a data de validade
      data_atual         = oRegXML.Item(0).selectSingleNode("./DATA_ATUAL").Text

      if trim(num_reembolso) <> "" then

            if oRegXML.Item(0).selectSingleNode("./NUM_REEMBOLSO_ANS").Text <> "" then
                num_reembolso = oRegXML.Item(0).selectSingleNode("./NUM_REEMBOLSO_ANS").Text
            end if
            num_reembolso_ant    = oRegXML.Item(0).selectSingleNode("./NUM_REEMBOLSO").Text
         nome_situacao      = oRegXML.Item(0).selectSingleNode("./NOME_SITUACAO").Text
         num_associado      = oRegXML.Item(0).selectSingleNode("./NUM_ASSOCIADO").Text
         cod_ts            = oRegXML.Item(0).selectSingleNode("./COD_TS").Text
         ind_situacao      = oRegXML.Item(0).selectSingleNode("./IND_SITUACAO").Text
         ind_sexo         = oRegXML.Item(0).selectSingleNode("./IND_SEXO").Text
         tipo_associado      = oRegXML.Item(0).selectSingleNode("./TIPO_ASSOCIADO").Text
         cod_ts_resp         = oRegXML.Item(0).selectSingleNode("./COD_TS_RESP").Text
         cod_dependencia      = oRegXML.Item(0).selectSingleNode("./COD_DEPENDENCIA").Text
         cod_ts_tit         = oRegXML.Item(0).selectSingleNode("./COD_TS_TIT").Text
         cod_ts_contrato      = oRegXML.Item(0).selectSingleNode("./COD_TS_CONTRATO").Text
         num_contrato      = oRegXML.Item(0).selectSingleNode("./NUM_CONTRATO").Text
         data_nascimento      = oRegXML.Item(0).selectSingleNode("./DATA_NASCIMENTO").Text
         cod_tratamento      = oRegXML.Item(0).selectSingleNode("./COD_TRATAMENTO").Text
         cod_acomodacao      = oRegXML.Item(0).selectSingleNode("./COD_ACOMODACAO").Text
         dt_inclusao_pedido         = oRegXML.Item(0).selectSingleNode("./DT_INCLUSAO").Text
         txt_observacao      = trataStr(oRegXML.Item(0).selectSingleNode("./TXT_OBSERVACAO").Text)
         txt_observacao_operadora = trataStr(oRegXML.Item(0).selectSingleNode("./TXT_OBSERVACAO_OPERADORA").Text)
         'ind_situacao_pedido   = oRegXML.Item(0).selectSingleNode("./IND_SITUACAO_PEDIDO").Text
         dt_situacao           = oRegXML.Item(0).selectSingleNode("./DT_SITUACAO_PEDIDO").Text
         ind_insc_fiscal      = oRegXML.Item(0).selectSingleNode("./IND_INSC_FISCAL").Text
         nome_prestador      = oRegXML.Item(0).selectSingleNode("./NOME_PRESTADOR").Text
         num_insc_fiscal      = oRegXML.Item(0).selectSingleNode("./NUM_INSC_FISCAL").Text
         if ind_insc_fiscal = "F" AND trim(num_insc_fiscal) <> "" then
            num_insc_fiscal = FormataCPF(num_insc_fiscal)
         elseif ind_insc_fiscal = "J" AND trim(num_insc_fiscal) <> "" then
            num_insc_fiscal = FormataCGC(num_insc_fiscal)
         end if
         num_crm            = oRegXML.Item(0).selectSingleNode("./NUM_CRM").Text
         uf_conselho         = oRegXML.Item(0).selectSingleNode("./UF_CONSELHO").Text
         sigla_conselho      = oRegXML.Item(0).selectSingleNode("./SIGLA_CONSELHO").Text
         val_calculado      = oRegXML.Item(0).selectSingleNode("./VAL_CALCULADO").Text
         val_reembolsado      = oRegXML.Item(0).selectSingleNode("./VAL_REEMBOLSADO").Text
         val_informado      = oRegXML.Item(0).selectSingleNode("./VAL_INFORMADO").Text
         cod_usuario_pedido   = oRegXML.Item(0).selectSingleNode("./COD_USUARIO_SIT").Text
         ind_carater         = oRegXML.Item(0).selectSingleNode("./IND_CARATER").Text
         cnes            = oRegXML.Item(0).selectSingleNode("./CNES").Text
         cod_cbo            = oRegXML.Item(0).selectSingleNode("./COD_CBO").Text
         nome_cbo         = oRegXML.Item(0).selectSingleNode("./NOME_CBO").Text
         dt_indeferimento   = oRegXML.Item(0).selectSingleNode("./DT_INDEFERIMENTO").Text
         dt_analise         = oRegXML.Item(0).selectSingleNode("./DT_ANALISE").Text
         cod_plano         = oRegXML.Item(0).selectSingleNode("./COD_PLANO").Text
         cod_entidade_ts_tit   = oRegXML.Item(0).selectSingleNode("./COD_ENTIDADE_TS_TIT").Text
         ind_acomodacao      = oRegXML.Item(0).selectSingleNode("./IND_ACOMODACAO").Text
         cod_motivo_reembolso          = oRegXML.Item(0).selectSingleNode("./COD_MOTIVO_REEMBOLSO").Text
         qtd_dias_reembolso = oRegXML.Item(0).selectSingleNode("./QTD_DIAS_REEMBOLSO").Text
         dt_provavel_reembolso = oRegXML.Item(0).selectSingleNode("./DT_PROVAVEL_REEMBOLSO").Text
         qtd_dias_reemb_uteis = oRegXML.Item(0).selectSingleNode("./QTD_DIAS_REEMB_UTEIS").Text

         txt_num_fax         = oRegXML.Item(0).selectSingleNode("./TXT_NUM_FAX").Text
         txt_ddd_fax         = oRegXML.Item(0).selectSingleNode("./TXT_DDD_FAX").Text
         txt_ramal_fax      = oRegXML.Item(0).selectSingleNode("./TXT_RAMAL_FAX").Text
         txt_email         = oRegXML.Item(0).selectSingleNode("./TXT_EMAIL").Text
         ddd_residencial     = oRegXML.Item(0).selectSingleNode("./DDD_RESIDENCIAL").Text
         tel_residencial     = oRegXML.Item(0).selectSingleNode("./TEL_RESIDENCIAL").Text
         ddd_comercial       = oRegXML.Item(0).selectSingleNode("./DDD_COMERCIAL").Text
         tel_comercial       = oRegXML.Item(0).selectSingleNode("./TEL_COMERCIAL").Text
         ddd_celular         = oRegXML.Item(0).selectSingleNode("./DDD_CELULAR").Text
         tel_celular         = oRegXML.Item(0).selectSingleNode("./TEL_CELULAR").Text

         ind_tipo_emissao   = oRegXML.Item(0).selectSingleNode("./IND_TIPO_EMISSAO").Text
         cod_origem = oRegXML.Item(0).selectSingleNode("./COD_ORIGEM").Text
         ind_tipo_reembolso = oRegXML.Item(0).selectSingleNode("./IND_TIPO_REEMBOLSO").Text
         cod_inspetoria_ts_abertura = oRegXML.Item(0).selectSingleNode("./COD_INSPETORIA_TS_ABERTURA").Text
         nome_situacao_pedido = oRegXML.Item(0).selectSingleNode("./NOME_SITUACAO").Text
         num_internacao       = oRegXML.Item(0).selectSingleNode("./NUM_INTERNACAO").Text

		 if ind_tipo_reembolso = "1" then
		 	sWhereAtendimento = " where cod_tratamento in (5, 45) "
		 	sWhereMotivo = "and cod_motivo_reembolso not in ('URG', 'ANE') "
		 elseif ind_tipo_reembolso = "2" then
		 	sWhereAtendimento = "where cod_tratamento not in (5, 45) and ind_internado = 'N'"
		 else
		 	sWhereAtendimento = "where cod_tratamento not in (5, 45) and ind_internado = 'S'"
		 end if
				

         qtd_glosa_analise   = oRegXML.Item(0).selectSingleNode("./QTD_GLOSA_ANALISE").Text
         qtd_glosa_analisada   = oRegXML.Item(0).selectSingleNode("./QTD_GLOSA_ANALISADA").Text
         qtd_grupo_analise   = oRegXML.Item(0).selectSingleNode("./QTD_GRUPO_ANALISE").Text

         if ind_acomodacao = "" then
            ind_acomodacao = ind_tipo_acomodacao
         end if
		 
		cod_solicitante     = oRegXML.Item(0).selectSingleNode("./COD_SOLICITANTE").Text
		cod_cbo_solicitante = oRegXML.Item(0).selectSingleNode("./COD_CBO_SOLICITANTE").Text
		cnes_solicitante = oRegXML.Item(0).selectSingleNode("./CNES_SOLICITANTE").Text
		num_insc_fiscal_solicitante = oRegXML.Item(0).selectSingleNode("./NUM_INSC_FISCAL_SOLICITANTE").Text
		nome_prestador_solicitante = oRegXML.Item(0).selectSingleNode("./NOME_SOLICITANTE").Text
		sigla_conselho_solicitante = oRegXML.Item(0).selectSingleNode("./SIGLA_CONSELHO_SOLICITANTE").Text
		num_crm_solicitante = oRegXML.Item(0).selectSingleNode("./NUM_CRM_SOLICITANTE").Text
		uf_conselho_solicitante = oRegXML.Item(0).selectSingleNode("./UF_CONSELHO_SOLICITANTE").Text
		ind_insc_fiscal_solicitante = oRegXML.Item(0).selectSingleNode("./IND_TIPO_PESSOA_SOLICITANTE").Text		
		nome_cbo_solicitante = oRegXML.Item(0).selectSingleNode("./NOME_CBO_SOLICITANTE").Text		
		
		if ind_insc_fiscal_solicitante = "F" AND trim(num_insc_fiscal_solicitante) <> "" then
			num_insc_fiscal_solicitante = FormataCPF(num_insc_fiscal_solicitante)
		elseif ind_insc_fiscal_solicitante = "J" AND trim(num_insc_fiscal_solicitante) <> "" then
			num_insc_fiscal_solicitante = FormataCGC(num_insc_fiscal_solicitante)
		end if

      end if
   end if

   Set oXML = Nothing
   Set oRegXML = Nothing

   if Trim(num_associado) <> "" then
      '------------------------------------------------
      'Recuperar dados do Beneficiário
      '------------------------------------------------
      Redim vet_PL(2,4)

      vet_PL(1, 1) = "OUT"
      vet_PL(1, 2) = "adLongVarChar"
      vet_PL(1, 3) = "p_xml_retorno"

      vet_PL(2, 1) = "IN"
      vet_PL(2, 2) = "adVarChar"
      vet_PL(2, 3) = "p_num_associado"
      vet_PL(2, 4) = num_associado

       Call ExecutaPLOracle (   CStr(session("ace_usuario")),_
                          CStr(session("ace_senha")),_
                        CStr(session("ace_ip")),_
                        CStr(session("ace_sistema")),_
                        CStr(session("ace_modulo")),_
                        "RB_PREVIA_REEMBOLSO.get_xml_associado", _
                        vet_PL, _
                        false )

      FechaConexao()

      xml_associado = vet_PL(1, 4)

       if trim(xml_associado) <> "" then
           Set oXML = CreateObject("Microsoft.XMLDOM")
           oXML.async = False
           oXML.loadXML(xml_associado)
           Set oRegXML = oXML.getElementsByTagName("ROW")

            sDisplayBenef = "none"

           if oRegXML.Item(0).selectSingleNode("./COD_RETORNO").Text <> "0" then
              txt_msg = "Erro ao carregar beneficiário: " & oRegXML.Item(0).selectSingleNode("./MSG_RETORNO").Text
              cod_ts = ""
              num_associado = ""
           else

               sDisplayBenef = ""

              cod_ts              = oRegXML.Item(0).selectSingleNode("./COD_TS").Text
              num_associado      = oRegXML.Item(0).selectSingleNode("./NUM_ASSOCIADO").Text
              cod_ts_contrato      = oRegXML.Item(0).selectSingleNode("./COD_TS_CONTRATO").Text
              'tipo_empresa      = oRegXML.Item(0).selectSingleNode("./TIPO_EMPRESA").Text
              nome_associado      = oRegXML.Item(0).selectSingleNode("./NOME_ASSOCIADO").Text
              num_contrato      = oRegXML.Item(0).selectSingleNode("./NUM_CONTRATO").Text
              if trim(num_contrato) <> "" then
                  nome_contrato_exibicao      = num_contrato & " - " & oRegXML.Item(0).selectSingleNode("./NOME_CONTRATO").Text
              end if
            nome_contrato = oRegXML.Item(0).selectSingleNode("./NOME_CONTRATO").Text
              data_nascimento      = oRegXML.Item(0).selectSingleNode("./DATA_NASCIMENTO").Text
             idade_associado         = oRegXML.Item(0).selectSingleNode("./IDADE_ASSOCIADO").Text
             idade_associado_exibicao      = idade_associado & " anos"
             cod_plano         = oRegXML.Item(0).selectSingleNode("./COD_PLANO").Text
              nome_plano          = cod_plano & " - " & oRegXML.Item(0).selectSingleNode("./NOME_PLANO").Text
            cod_rede             = oRegXML.Item(0).selectSingleNode("./COD_REDE").Text
            nom_rede          = cod_rede & " - " & oRegXML.Item(0).selectSingleNode("./NOM_REDE").Text
            cod_operadora             = oRegXML.Item(0).selectSingleNode("./COD_OPERADORA").Text
            nome_operadora          = cod_operadora & " - " & oRegXML.Item(0).selectSingleNode("./NOM_OPERADORA").Text
            cod_marca                = oRegXML.Item(0).selectSingleNode("./COD_MARCA").Text
            nome_filial             = oRegXML.Item(0).selectSingleNode("./NOME_SUCURSAL").Text & " / " & oRegXML.Item(0).selectSingleNode("./NOME_INSPETORIA").Text
            cod_inspetoria_ts   = oRegXML.Item(0).selectSingleNode("./COD_INSPETORIA_TS").Text
            cod_tipo_contrato   = oRegXML.Item(0).selectSingleNode("./COD_TIPO_CONTRATO").Text
              ind_tipo_acomodacao   = oRegXML.Item(0).selectSingleNode("./IND_ACOMODACAO").Text
              data_inclusao      = oRegXML.Item(0).selectSingleNode("./DATA_INCLUSAO").Text
              data_exclusao      = oRegXML.Item(0).selectSingleNode("./DATA_EXCLUSAO").Text
              ind_situacao      = oRegXML.Item(0).selectSingleNode("./IND_SITUACAO").Text
              cod_empresa          = oRegXML.Item(0).selectSingleNode("./COD_EMPRESA").Text
              cod_grupo_empresa       = oRegXML.Item(0).selectSingleNode("./COD_GRUPO_EMPRESA").Text
              'cod_ts_resp          = oRegXML.Item(0).selectSingleNode("./COD_TS_RESP").Text
              cod_dependencia      = oRegXML.Item(0).selectSingleNode("./COD_DEPENDENCIA").Text
              cod_ts_tit          = oRegXML.Item(0).selectSingleNode("./COD_TS_TIT").Text
              nom_situacao_associado   = oRegXML.Item(0).selectSingleNode("./NOM_SITUACAO_ASSOCIADO").Text
              cod_titular_contrato   = oRegXML.Item(0).selectSingleNode("./COD_TITULAR_CONTRATO").Text
              tipo_associado      = oRegXML.Item(0).selectSingleNode("./TIPO_ASSOCIADO").Text
              ind_sexo          = oRegXML.Item(0).selectSingleNode("./IND_SEXO").Text
              nome_situacao_esp = oRegXML.Item(0).selectSingleNode("NOME_SITUACAO_ESP").Text
            nome_imagem         = oRegXML.Item(0).selectSingleNode("NOM_IMAGEM").Text
            cod_acao_ts            = oRegXML.Item(0).selectSingleNode("./COD_ACAO_TS").Text
            tipo_pessoa_contrato   = oRegXML.Item(0).selectSingleNode("./TIPO_PESSOA_CONTRATO").Text
            ind_origem_associado = oRegXML.Item(0).selectSingleNode("./IND_ORIGEM_ASSOCIADO").Text
            ind_regulamentado      = oRegXML.Item(0).selectSingleNode("./IND_REGULAMENTADO").Text
            ind_plano_com_reembolso = oRegXML.Item(0).selectSingleNode("./IND_PLANO_COM_REEMBOLSO").Text

            num_titular = oRegXML.Item(0).selectSingleNode("./NUM_ASSOCIADO_TIT").Text
            nome_titular = oRegXML.Item(0).selectSingleNode("./NOME_ASSOCIADO_TIT").Text

            ind_erro_ws        = oRegXML.Item(0).selectSingleNode("./IND_ERRO_WS").Text
            msg_erro_ws       = trataStr(oRegXML.Item(0).selectSingleNode("./MSG_ERRO_WS").Text)
			
			'DADOS PARA PAGAMENTO
			 data_adaptacao      = oRegXML.Item(0).selectSingleNode("./DATA_ADAPTACAO").Text
			 tem_aditivo         = oRegXML.Item(0).selectSingleNode("./TEM_ADITIVO").Text
			
            ' adicionado para pesquisa de contrato das telas de atendimento
            dt_ini_vigencia = oRegXML.Item(0).selectSingleNode("./DT_INI_VIGENCIA").Text
            ind_acao_judicial_cliente = oRegXML.Item(0).selectSingleNode("./INDACAOJUDICIALCLIENTE").Text
			
            if ind_sexo = "M" then
               txt_sexo = "Masculino"
            elseif ind_sexo = "F" then
               txt_sexo = "Feminino"
            end if

            if tipo_associado = "T" then
                StrTipoAssociado = "<B>TITULAR</B>"
            elseif tipo_associado = "D" then
                StrTipoAssociado = "<B>DEPENDENTE</B>"
            elseif tipo_associado = "P" then
               StrTipoAssociado = "<B>PRATOCINADOR</B>"
                end if

            if txt_email <> "" then
               ind_tipo_emissao = "E"
            end if

            if ind_tipo_acomodacao = "A" then
               nome_tipo_acomodacao = "Individual"
            else
               nome_tipo_acomodacao = "Coletiva"
            end if			

            end if
       end if
   end if
end if

if ind_forma_abertura = "IN" or ind_forma_abertura = "AL" then
	'VERIFICA SE EXISTE FAMÍLIA PARA TROCAR NA PREVIA
	Redim vet_PL(2,4)

	vet_PL(1, 1) = "IN"
	vet_PL(1, 2) = "adDouble"
	vet_PL(1, 3) = "p_cod_ts"
	vet_PL(1, 4) = cod_ts

	vet_PL(2, 1) = "OUT"
	vet_PL(2, 2) = "adDouble"
	vet_PL(2, 3) = "p_qtd_familia"
	
	Call ExecutaPLOracle (	CStr(session("ace_usuario")),_
							CStr(session("ace_senha")),_
							CStr(session("ace_ip")),_
							CStr(session("ace_sistema")),_
							CStr(session("ace_modulo")),_
							"RB_PREVIA_REEMBOLSO.getQtdFamilia", _
							vet_PL, _
							false )
	qtd_familia = vet_PL(2,4)
end if
			
'------------------------------------------------------------
        ' Recuperar informações de Mensagens de Atendimento
        '------------------------------------------------------------

        Redim vet_PL(8,4)

        vet_PL(1, 1) = "OUT"
        vet_PL(1, 2) = "adDouble"
        vet_PL(1, 3) = "p_cod_retorno"

        vet_PL(2, 1) = "OUT"
        vet_PL(2, 2) = "adVarChar"
        vet_PL(2, 3) = "p_msg_retorno"

        vet_PL(3, 1) = "OUT"
        vet_PL(3, 2) = "adLongVarChar"
        vet_PL(3, 3) = "p_xml_retorno"

        vet_PL(4, 1) = "IN"
        vet_PL(4, 2) = "adVarChar"
        vet_PL(4, 3) = "p_num_associado"
        vet_PL(4, 4) = num_associado

        vet_PL(5, 1) = "IN"
        vet_PL(5, 2) = "adVarChar"
        vet_PL(5, 3) = "p_cod_ts"
        vet_PL(5, 4) = cod_ts

        vet_PL(6, 1) = "IN"
        vet_PL(6, 2) = "adVarChar"
        vet_PL(6, 3) = "p_cod_ts_tit"
        vet_PL(6, 4) = cod_ts_tit

        vet_PL(7, 1) = "IN"
        vet_PL(7, 2) = "adVarChar"
        vet_PL(7, 3) = "p_cod_ts_contrato"
        vet_PL(7, 4) = cod_ts_contrato

        vet_PL(8, 1) = "IN"
        vet_PL(8, 2) = "adVarChar"
        vet_PL(8, 3) = "p_cod_plano"
        vet_PL(8, 4) = cod_plano

        Call ExecutaPLOracle ( CStr(session("ace_usuario")),_
                            CStr(session("ace_senha")),_
                            CStr(session("ace_ip")),_
                            CStr(session("ace_sistema")),_
                            CStr(session("ace_modulo")),_
                            "RB_PROCESSO.get_stratdbeneficiarioPrevia", _
                            vet_PL, _
                            false )


        sXMLD = vet_PL(3, 4)

        Set oXMLAtendimento = CreateObject("Microsoft.XMLDOM")
        oXMLAtendimento.async = False
        oXMLAtendimento.loadXML(sXMLD)
        Set oRegXMLAtendimento = oXMLAtendimento.getElementsByTagName("ATENDIMENTO")


        if oRegXMLAtendimento.Length > 0 then

            txt_mensagem       = oRegXMLAtendimento.Item(0).selectSingleNode("./TXT_MENSAGEM").Text
            ind_forma_exibicao = oRegXMLAtendimento.Item(0).selectSingleNode("./IND_FORMA_EXIBICAO").Text

            if ind_forma_exibicao = "1" or ind_forma_exibicao = "2" then
                txt_ind_mensagem = ""
                if ind_forma_exibicao = "2" then
                    aux_tem_msg = "S"
                end if
            else
                txt_ind_mensagem = "none"
            end if
        end if

        Set oXMLAtendimento = Nothing
        Set oRegXMLAtendimento = Nothing
%>

<%AbreTable()%>
<font class="subtitulos"><%=txt_subtitulo%></font>
<%FechaTable()%>

<%Call SetWaitBar()%>

<%AbreTable()%>

<div id="txt_msg" class="msg" align="center"><%=txt_msg%></div>

<form method="POST" name="form01">

<input type="hidden" name="ind_acesso_operadora" value="<%if bAcessoOperadora then response.write "S" else response.write "N"%>">
<input type="hidden" name="ult_num_seq_item"     value="<%=ult_num_seq_item%>">
<input type="hidden" name="ind_processo"         value="<%=ind_processo %>" />
<input type="hidden" name="num_reembolso_ant"         value="<%=num_reembolso_ant%>" />
<input type="hidden" name="valida_perfil_fraude" id="valida_perfil_fraude" value="" >
<input type="hidden" name="tipo_crm_cnpj" id="tipo_crm_cnpj" value="" >
<table width="100%" align="center" border="0">
<%
   if ind_forma_abertura <> "IN" then%>
      <tr>
         <td width="05%" class="label_right" nowrap>Nº Prévia&nbsp;</td>
            <td colspan="3" nowrap>
                <input type="text" name="num_reembolso" value="<%=num_reembolso%>" size="25" tabindex="1" maxlength="20" OnKeyDown="TeclaEnter();" onKeyPress="javascript:MascInt();" onChange="Reexecute();" <%if trim(num_reembolso) <> "" then response.Write"Readonly class=camposblocks" %>>
            <%
            if trim(num_reembolso) = "" then
               Set oPesquisa = Server.CreateObject("tsgen0110.MontaLupa")
               oPesquisa.FuncaoExecutar  = ""
               oPesquisa.NomeASP         = "../../gen/asp/gen0150a.asp"
               oPesquisa.NomeIdPesquisa  = "Pesquisa_Previa"
               oPesquisa.Display         = ""
               oPesquisa.IndSubmit       = "S"
               oPesquisa.NomeCampoCodTS  = ""
               oPesquisa.NomeCampoDesc   = ""
               oPesquisa.NomeCampoCod    = "num_reembolso"
               oPesquisa.AbreModal       = "S"
               oPesquisa.NomePesquisa    = "Pesquisa Prévia Reembolso"
               oPesquisa.PopupWidth      = "1000"
               oPesquisa.PopupHeight     = "500"
               CALL oPesquisa.MontaLupaPesquisa()

               set oPesquisa = nothing
            else
            'GLOSAS
                sImgErro = ""
                    if Cint("0" & qtd_glosa_analise) > 0 then 'Analisada
                        sImgErro = "aviso_vermelho.gif"
                    elseif Cint("0" & qtd_glosa_analisada) > 0 then
                        sImgErro = "aviso_amarelo.gif"
                    end if

                    if trim(sImgErro) <> "" then
                        Response.Write "&nbsp;&nbsp;<img align='middle' style='cursor:hand' name='Pesquisa_MSG_Erro' width='20' height='20' src='/gen/img/" & sImgErro & "'  border='0' Title='Glosas Encontradas' onClick=""javascript:AbreGlosa('0', 'S');"">"
                    end if

                    'Icone de Grupo Ocorrência
                    if Cint("0" & qtd_grupo_analise) > 0 then
                        Response.Write "&nbsp;<img align='middle' style='cursor:hand' name='Pesquisa_Liberacao' width='22' height='22' src='/gen/img/LibAut.gif' border='0' Title='Análise Especial' onClick=""javascript:AbrePesquisa('/rbm/ASP/RBM1012e.asp?num_reembolso=" & num_reembolso_ant & "&ind_forma_abertura=" & ind_forma_abertura & "','Pesquisa','Análise Especial', 1000, 400, 5, 5, 'S')"" >"
                    end if

            %>

               &nbsp;&nbsp;
               Situação&nbsp;
               <input type="text" name="nome_situacao_pedido" value="<%=nome_situacao_pedido%>" size="35" tabindex="1" OnKeyDown="TeclaEnter();" onKeyPress="javascript:MascInt();" onChange="Reexecute();" Readonly class=camposblocks >
            <%end if%>
         </td>
      </tr>
   <%end if

   if ind_forma_abertura = "IN" OR (ind_forma_abertura <> "IN" AND trim(num_reembolso) <> "") then

   %>
      <!-- DADOS DO ASSOCIADO -->
      <tr>
         <td width="15%" class="label_right">Beneficiário&nbsp;</td>
         <td nowrap>
            <input type="text"  name="num_associado" value="<%=num_associado%>" size="23" tabindex="1" maxlength="<%=qtdMaxLength%>" OnKeyDown="TeclaEnter();" onKeyPress="javascript:MascInt();" onChange="CarregaDadosAssociado();" <%=txt_disabled_cam%>>
            <% if bAcessoOperadora and trim(num_reembolso) = "" and ( ind_acesso_cam <> "S" and txt_modulo <> 40 ) then %>
               <img name="Pesquisa_Beneficiario" width="16" height="16" id="Pesquisa_Beneficiario" style="cursor: hand;" onclick="javascript:PesquisaBeneficiario();" Title="Pesquisa Beneficiário" src="/gen/mid/lupa.gif" border="0" />
            <% end if %>
			
			<img align='middle' name='Pesquisa_Familia' style="cursor:hand; <% if qtd_familia < 2 then %>display:'none'<%end if%> " width='20' height='20' src='/gen/img/familia_rb.png' border='0' title='Trocar Beneficiário por outro da Família' onClick="javascript:AbrePesquisaFamilia();" >	
            <input type="text" Readonly class=camposblocks name="nome_associado" value="<%=nome_associado%>" size="50" onKeyPress="javascript:MascAlfaNum()" OnKeyDown="TeclaEnter()" maxlength="60">
			

             <% if bAcessoOperadora then %>
            <!--CHAMADA DA CONSULTA PADRÃO-->
            <img align='middle' name='Pesquisa_Padrao' <%if trim(num_reembolso) = "" then%>style="cursor:'hand';display:'none'"<%end if%> width='20' height='20' src='/gen/mid/user.gif' border='0' Title='Dados Beneficiário' onClick="javascript:AbrePesquisaPadrao();">

            <%end if%>

            <!-- VIP -->
            <% if nome_imagem <> "" then %>
               <img align='middle' name="img_situacao_esp" src="/gen/img/<%=nome_imagem%>" Title="<%=nome_situacao_esp%>">
            <% else %>
               <img align='middle' style='display:none' name="img_situacao_esp" src="" Title="">
            <% end if %>

            <img align='middle' name='Pesquisa_Previa1' <%if trim(num_reembolso) = "" and trim(num_contrato) = "" then%>style="cursor:'hand';display:'none'"<%end if%> width='20' height='20' src='/gen/img/contrato_rb.png' border='0' Title='Pesquisar Prévias por Contrato' onClick="javascript:AbrePesquisaPrevia('C');">
            <img align='middle' name='Pesquisa_Previa2' <%if trim(num_reembolso) = "" then%>style="cursor:'hand';display:'none'"<%end if%> width='20' height='20' src='/gen/img/familia_rb.png' border='0' Title='Pesquisar Prévias por Família' onClick="javascript:AbrePesquisaPrevia('T');">
            <img align='middle' name='Pesquisa_Previa3' <%if trim(num_reembolso) = "" then%>style="cursor:'hand';display:'none'"<%end if%> width='20' height='20' src='/gen/img/beneficiario_rb.png' border='0' Title='Pesquisar Prévias por Beneficiário' onClick="javascript:AbrePesquisaPrevia('B');">
            <img align='middle' name='Pesquisa_Ocorrencia' <%if trim(num_reembolso) = "" or trim(cod_ts) = "" then%>style="cursor:'hand';display:'none'"<%end if%> width='20' height='20' src='/gen/img/img0034e.gif' border='0' Title='Pesquisar Ocorrêcias' onClick="javascript:AbrePesquisaOcorrencia();">

               <img align='middle' src="\gen\img\atd_aviso_msg.gif?<%Response.write Day(date)%>" name='Pesquisa_Mensagem' id="ico_mensagem" Title="Beneficiário possui mensagens" onclick="exibeMensagemAtd(4)" style='cursor:hand;display:<%=txt_ind_mensagem%>' width='20' height='20' border='0'>

            <%if cod_acao_ts <> "" and trim(cod_ts) <> "" then %>
               <img align='middle' name='Pesquisa_Judicial' style="cursor:hand;display:'<% if trim(num_associado) = "" then response.write "none" %>'" width='20' height='20' src='/gen/img/icons/balanca_vermelha.gif' border='0' Title='Dados Judiciais' onClick="javascript:abreAcaoJudicial();">
            <% end if %>
            <!--ACAO JUDICIAL CLIENTE-->
            <img align='middle'  name='Pesquisa_Acao_Judicial_cliente' id='Pesquisa_Acao_Judicial_cliente' <%if ind_acao_judicial_cliente <> "S" then%>style="display:'none'"<%end if%> width='20' height='20' src='/gen/img/lupa_judicial_hab.png' border='0' title='Consultar Prevenção a Fraude' onClick="javascript:AbreAcaoJudicialCliente();">
            <input type="hidden" name="cod_ts"                        value="<%=cod_ts%>">
            <input type="hidden" name="data_inclusao"               value="<%=dt_inclusao%>">
            <input type="hidden" name="data_exclusao"               value="<%=dt_exclusao%>">
            <input type="hidden" name="ind_situacao"               value="<%=ind_situacao%>">
            <input type="hidden" name="tipo_associado"               value="<%=tipo_associado%>">
            <input type="hidden" name="cod_ts_tit"                  value="<%=cod_ts_tit%>">
            <input type="hidden" name="num_titular"                  value="<%=num_titular%>">
            <input type="hidden" name="nome_titular"               value="<%=nome_titular%>">
            <input type="hidden" name="cod_entidade_ts_tit"          value="<%=cod_entidade_ts_tit%>">
            <input type="hidden" name="ind_regulamentado"             value="<%=ind_regulamentado%>">
            <input type="hidden" name="ind_origem_associado"          value="<%=ind_origem_associado%>">
            <input type="hidden" name="ind_plano_com_reembolso"       value="<%=ind_plano_com_reembolso%>">
            <input type="hidden" name="ind_erro_ws"                  value="<%=ind_erro_ws%>">
            <input type="hidden" name="msg_erro_ws"                  value="<%=msg_erro_ws%>">
            <input type="hidden" name="tipo_pessoa_contrato"         value="<%=tipo_pessoa_contrato%>">

            <input type="hidden" name="txt_mensagem"     value="<%=txt_mensagem %>">
            <input type="hidden" name="ind_forma_exibicao"     value="<%=ind_forma_exibicao %>">
            <input type="hidden" name="cod_grupo_empresa"     value="<%=cod_grupo_empresa %>">
            <input type="hidden" name="aux_tem_msg"          id="aux_tem_msg"      value="<%=aux_tem_msg%>" />
            <input type="hidden" name="ind_acao_judicial_cliente" id="ind_acao_judicial_cliente" value= "">
            <input type="hidden" name="valida_perfil_fraude" id="valida_perfil_fraude" value="" >
			
			<input type="hidden" name="data_adaptacao"              value="<%=data_adaptacao%>">
			<input type="hidden" name="tem_aditivo"                 value="<%=tem_aditivo%>">
			
         </td>
      </tr>

      <tr>
         <td colspan="2">
            <!-- ASSOCIADO EXISTENTE -------------------------------------------------------------------------->
            <table id="tbConsultaASS" width="100%" align="center" border="0" <%if ind_forma_abertura = "IN" then%>style="display='none'"<%end if%>>
               <tr>
                  <td width="15%" class="label_right">Operadora&nbsp;</td>
                  <td>
                     <input type="text" Readonly class=camposblocks id="nome_operadora" name="nome_operadora" value="<%=nome_operadora%>" size="50">
                     <input type="hidden" id="cod_operadora" name="cod_operadora" value="<%=cod_operadora%>">
                     <input type="hidden" id="cod_marca" name="cod_marca" value="<%=cod_marca%>">
                     &nbsp;&nbsp;&nbsp;
                     <font class="label_right" style="display:<% if bAcessoOperadora = false then response.write "none" %>">Filial/Unidade&nbsp;</font>
                     <input type="text" Readonly class=camposblocks name="nome_filial" value="<%=nome_filial%>" size="50" style="display:<% if bAcessoOperadora = false then response.write "none" %>">
                     <input type="hidden" id="cod_inspetoria_ts" name="cod_inspetoria_ts" value="<%=cod_inspetoria_ts%>">
                  </td>
               </tr>

               <tr style="display:<% if bAcessoOperadora = false then response.write "none" %>">
                  <td class="label_right">Contrato&nbsp;</td>
                  <td nowrap>
                     <input type="text" id="nome_contrato_exibicao" name="nome_contrato_exibicao" size="55" Readonly class=camposblocks value="<%=nome_contrato%>">
                     <input type="hidden" id="cod_ts_contrato" name="cod_ts_contrato" value="<%=cod_ts_contrato%>">
                     <input type="hidden" id="num_contrato" name="num_contrato" value="<%=num_contrato%>">
                     <input type="hidden" id="nome_contrato" name="nome_contrato" value="<%=nome_contrato%>">
                     <input type="hidden" id="dt_ini_vigencia" name="dt_ini_vigencia" value="<%=dt_ini_vigencia%>">
                     <img align='middle' name='Pesquisa_contrato' <%if trim(num_reembolso) = "" then%>style="cursor:'hand';display:'none'"<%end if%> width='20' height='20' src='/gen/img/DbAppsPalette.gif' border='0' Title='Regras de Reembolso' onClick="javascript:AbrePesquisaContrato();">&nbsp;&nbsp;&nbsp;
                            <font class="label_right">Tipo Acomodação&nbsp;</font>
                     <input type="text" Readonly class=camposblocks id="nome_tipo_acomodacao" name="nome_tipo_acomodacao" value="<%=nome_tipo_acomodacao%>" size="20">
                     <input type="hidden" id="ind_tipo_acomodacao" name="ind_tipo_acomodacao" value="<%=ind_tipo_acomodacao%>">
					 <%
                            if data_adaptacao <> "" then
                                %>
                                <label id="lblPlano" style="color:red"><B>Adaptado</B></label>
                                <%
                            elseif tem_aditivo = "S" then
                                %>
                                <label id="lblPlano" style="color:red"><B>Equalizado</B></label>
                                <%
                            elseif ind_regulamentado = "N" then 
                                %>
                                <label id="lblPlano" style="color:red"><B>Não Regulamentado</B></label>
                                <%
                            end if 
                            %>
                  </td>
               </tr>

               <tr>
                  <td class="label_right">Plano&nbsp;</td>
                  <td nowrap>
                     <input type="text" Readonly class=camposblocks name="nome_plano" value="<%=nome_plano%>" size="55">
                     <input type="hidden" id="cod_plano" name="cod_plano" value="<%=cod_plano%>">
                     <font class="label_right">Rede&nbsp;</font>
                     <input type="text" Readonly class=camposblocks name="nom_rede" value="<%=nom_rede%>" size="40">
                     <input type="hidden" id="cod_rede" name="cod_rede" value="<%=cod_rede%>">
                  </td>
               </tr>

               <tr>
                  <td class="label_right">
                     <div id='DvSituacao'>Situação</div>
                  </td>
                  <td>
                     <input type="text" Readonly class=camposblocks id="nom_situacao_associado" name="nom_situacao_associado" value="<%=nom_situacao_associado%>" size="60" style="display:'<%if bAcessoOperadora = false then response.write "none" %>'">
                     &nbsp;&nbsp;&nbsp;&nbsp;
                     <font class="label_right">Data Nasc.&nbsp;</font>
                     <input type="text" Readonly class=camposblocks id="data_nascimento" name="data_nascimento" value="<%=data_nascimento%>" size="11">
                     <input type="text" Readonly class=camposblocks id="idade_associado_exibicao" name="idade_associado_exibicao"      value="<%=idade_associado_exibicao%>" size="6">
                     <input type="hidden" name="idade_associado"      value="<%=idade_associado%>" >
                  </td>
               </tr>
               <tr>
                  <td class="label_right">
                     <font class="label_right">Telefone&nbsp;</font>
                  </td>
                  <td>
                     <input type="text" id="ddd_residencial" name="ddd_residencial" maxlength="3" value="<%=ddd_residencial%>" size="4" onKeyPress="javascript:MascInt();" />
                     <input type="text" id="tel_residencial" name="tel_residencial" maxlength="9" value="<%=tel_residencial%>" size="12" onKeyPress="javascript:MascInt();" />
                     &nbsp;&nbsp;&nbsp;&nbsp;
                     <font class="label_right">Comercial&nbsp;</font>
                     <input type="text" id="ddd_comercial" name="ddd_comercial" maxlength="3" value="<%=ddd_comercial%>" size="4" onKeyPress="javascript:MascInt();" />
                     <input type="text" id="tel_comercial" name="tel_comercial" maxlength="9" value="<%=tel_comercial%>" size="12" onKeyPress="javascript:MascInt();" />
                     &nbsp;&nbsp;&nbsp;&nbsp;
                     <font class="label_right">Celular&nbsp;</font>
                     <input type="text" id="ddd_celular" name="ddd_celular" maxlength="3" value="<%=ddd_celular%>" size="4" onKeyPress="javascript:MascInt();" />
                     <input type="text" id="tel_celular" name="tel_celular" maxlength="9" value="<%=tel_celular%>" size="12" onKeyPress="javascript:MascInt();" />
                     &nbsp;&nbsp;&nbsp;&nbsp;
                     <font class="label_right">Fax.&nbsp;</font>
                     <input type="text" id="txt_ddd_fax" name="txt_ddd_fax" maxlength="3" value="<%=txt_ddd_fax%>" size="4" onKeyPress="javascript:MascInt();" />
                     <input type="text" id="txt_num_fax" name="txt_num_fax" maxlength="9" value="<%=txt_num_fax%>" size="12" onKeyPress="javascript:MascInt();" />
                  </td>
               </tr>
               <tr>
                  <td class="label_right">
                     <font class="label_right">E-mail&nbsp;</font>
                  </td>
                  <td>
                     <input type="text" id="txt_email" name="txt_email" value="<%=txt_email%>" size="55" style="display:'<%if bAcessoOperadora = false then response.write "none" %>'">
                     &nbsp;&nbsp;&nbsp;&nbsp;Sexo&nbsp;
                     <input type="text" Readonly class=camposblocks name="txt_sexo"       value="<%=txt_sexo%>" size="12">
                     <input type="hidden" id="ind_sexo" name="ind_sexo"  value="<%=ind_sexo%>">
                  </td>
               </tr>
            </table>
         </td>
      </tr>
      <tr id ="tr_conteudo" <%if ind_forma_abertura = "IN" then%>style="display='none'"<%end if%>>
         <td colspan="2">
            <table width="100%" border="0" id="tb_dv_info">
               <tr>
                  <td class="grid_cabec" width="98%"><h1 class="grid_cabec"><label><font align="center" class="label_left"><b>&nbsp;Informações</b></label></h1></td>
                  <td class="label_right" ><h1 class="grid_cabec"><img id="img_dv_info" src="../../gen/img/btn-up.jpg" width="16" height="12" onClick="Expandir('dv_info');" style="cursor:hand" title="Clique para exibir Informações" /></h1></td>
               </tr>
            </table>
            <div id="dv_info" style='display:'><fieldset><% Call MontaInformacao() %></fieldset></div>

            <!--PROCEDIMENTOS -->
            <table width="100%" border="0" id="tb_dv_procedimento">
               <tr>
                  <td class="grid_cabec" width="98%"><h1 class="grid_cabec"><label><font align="center" class="label_left"><b>&nbsp;Procedimentos / Serviços</b></label></h1></td>
                  <td class="label_right" ><h1 class="grid_cabec"><img id="img_dv_procedimento" src="../../gen/img/btn-dn.jpg" width="16" height="12" onClick="Expandir('dv_procedimento');" style="cursor:hand" title="Clique para exibir procedimentos / serviços" /></h1></td>
               </tr>
            </table>
            <div id="dv_procedimento" style="display:'none'"><fieldset><% Call MontaProcedimento() %></fieldset></div>

         <% if ind_forma_abertura <> "IN" then %>
	<tr>	
			<td colspan="4">
		  <fieldset>
		    <legend><b>Valores totais</b></legend>
				 &nbsp;&nbsp;Valor Solicitado:
				<input type="text" name="val_moeda_estrangeira" value="<%=val_moeda_estrangeira%>" size="8" maxlength="10" onKeyPress="javascript:MascNum2()"  tabindex="0" style="TEXT-ALIGN: right" onchange="CalculaValorEmReais()" 	value="<%=ind_forma_abertura%>" readonly class="camposblocks" />
				 &nbsp;&nbsp;Valor calculado:
				<input type="text" name="val_moeda_estrangeira" value="<%=val_moeda_estrangeira%>" size="8" maxlength="10" onKeyPress="javascript:MascNum2()"  tabindex="0" style="TEXT-ALIGN: right" onchange="CalculaValorEmReais()"  value="<%=ind_forma_abertura%>" readonly class="camposblocks" />
				 &nbsp;&nbsp;Desconto de coparticipação:
				<input type="text" name="val_moeda_estrangeira" value="<%=val_moeda_estrangeira%>" size="8" maxlength="10" onKeyPress="javascript:MascNum2()"  tabindex="0" style="TEXT-ALIGN: right" onchange="CalculaValorEmReais()"  value="<%=ind_forma_abertura%>" readonly class="camposblocks" />
				 &nbsp;&nbsp;Valor total glosado:
				<input type="text" name="val_moeda_estrangeira" value="<%=val_moeda_estrangeira%>" size="8" maxlength="10" onKeyPress="javascript:MascNum2()"  tabindex="0" style="TEXT-ALIGN: right" onchange="CalculaValorEmReais()"  value="<%=ind_forma_abertura%>" readonly class="camposblocks" />
				 &nbsp;&nbsp;Valor reembolsado:
				<input type="text" name="val_moeda_estrangeira" value="<%=val_moeda_estrangeira%>" size="8" maxlength="10" onKeyPress="javascript:MascNum2()"  tabindex="0" style="TEXT-ALIGN: right" onchange="CalculaValorEmReais()"  value="<%=ind_forma_abertura%>" readonly class="camposblocks" />
			</fieldset>
		</td>
	</tr>
               <!--OCORRENCIAS -->
               <table width="100%" border="0" id="tb_dv_historico" style="display:'">
                  <tr>
                     <td class="grid_cabec" width="98%"><h1 class="grid_cabec"><label><font align="center" class="label_left"><b>&nbsp;Ocorrências</b></label></h1></td>
                     <td class="label_right" ><h1 class="grid_cabec"><img id="img_dv_ocorrencia" src="../../gen/img/btn-dn.jpg" width="16" height="12" onClick="Expandir('dv_ocorrencia');" style="cursor:hand" title="Clique para exibir Histórico" /></h1></td>
                  </tr>
               </table>
               <div id="dv_ocorrencia" style="display:'none'"><fieldset><% Call MontaOcorrencia() %></fieldset></div>
         <%end if%>
         </td>
      </tr>
      <% end if %>
</table>

<textarea name="xml_retorna" rows="10" cols="120" style="display:<%if trim(Request.QueryString("ind_debug")) <> "S" then response.write " none " %>"></textarea>
<input type="hidden" name="txt_subtitulo" value="<%=txt_subtitulo%>">
<input type="hidden" name="ind_executando"         value="<%=ind_executando%>">
<input type="hidden" name="ind_tipo_finalizacao"   value="">
<input type="hidden" name="cod_motivo"   value="">
<input type="hidden" name="cod_grupo_encaminhamento"   value="">
<input type="hidden" name="ind_tipo_encaminhamento"   value="">
<input type="hidden" name="txt_xml_pedido" value="">
<input type="hidden" name="ind_acesso_cam" value="<%=ind_acesso_cam%>">
<input type="hidden" name="cod_usuario_cam" value="<%=cod_usuario_cam%>">
<input type="hidden" name="ts_url_chamada_cam" value="<%=tsUrlChamadaCAM%>">
<input type="hidden" name="ind_forma_abertura" value="<%=ind_forma_abertura%>">
<input type="hidden" name="pgm" value="<%=pgm%>">
<input type="hidden" name="ind_retorno_relatorio" value="<%=ind_retorno_relatorio%>">
<!--Barata inicio-->
<input type="hidden" name="strauxurl" value="<%=strauxurl%>">
<input type="hidden" name="exibe_alerta_cadastral" value="<%=exibe_alerta_cadastral%>">
<!--Barata fim-->
<br>
</form>

<%

FechaTable()

'VOLTAR/CONTINUAR/LIMPAR/INCLUIR/ALTERAR/EXCLUIR/EXECUTAR/POPUP


    dim VetBotao(5)
   session("VetBotaoExtra") = ""

   if request("ind_forma_abertura")="IN" then
      VetBotao(1) = "acao_incluir();|gravar.gif|Incluir"
      session("VetBotaoExtra") = VetBotao

      if ind_popup = "S" then
         call MontaToolbar("S","N","N","N","N","N","N","S")
      else
         call MontaToolbar("N","N","S","N","N","N","N","N")
      end if
   elseif request("ind_forma_abertura")="AL" and num_reembolso<>"" then

      if botaoAlterar then
         VetBotao(1) = "acao_alterar();|Analise.gif|Analisar / Calcular Simulação"
      end if

      if botaoCancelar then
         VetBotao(2) = "ExecutarAcao(""CA"");|Cancelar.gif|Cancelar"
      end if

      if botaoFinalizar then
         VetBotao(3) = "ExecutarAcao(""FN"");|Aprovar.gif|Finalizar"
      end if

      if botaoTranferirGrupo then
         VetBotao(4) = "ExecutarAcao(""TR"");|encaminha.gif|Encaminhar/Transferir Grupo Análise"
      end if

      if session("retorno_pgm_sit") <> "" then
         VetBotao(5) = "ReexecutaSituacao();|VoltaSituacao.gif|Reexecutar Situação com últimos paramêtros"
      end if
      session("VetBotaoExtra") = VetBotao

      call MontaToolbar("N","N","S","N","N","N","N",ind_popup)
    else
      call MontaToolbar("N","N","S","N","N","N","N",ind_popup)
    end if


%>

<iframe style="WIDTH:0%; HEIGHT:0%" name="if_execucao" id="if_execucao" src="rbm0078c.asp" frameBorder="yes"></iframe>

</BODY>
</HTML>

<%
'------------------------------------------------------------------------------------------
Sub MontaCalendario(pCampo)  %>
  <img src="/gen/img/img.gif" id="img_<%=pCampo%>" style="cursor: pointer; border: 1px solid red;" title="Selecionar data" onmouseover="this.style.background='red'" onmouseout="this.style.background=''" />
  <script>
      Calendar.setup({
          inputField: "<%=pCampo%>",
          ifFormat: "%d/%m/%Y",
          button: "img_<%=pCampo%>",
          align: "Tl",
          singleClick: true
      });
  </script>
<%End Sub
'------------------------------------------------------------------------------------------
function LerCampo(pRegistro)
   if IsNull(pRegistro) then
      LerCampo = ""
   else
      if trim(pRegistro) <> "" then
         LerCampo = pRegistro
      else
         LerCampo = ""
      end if
   end if
end function
'------------------------------------------------------------------------------------------
function FormataCPF(cod_cpf)
   dim i, sAux
   if isnull(cod_cpf) then cod_cpf = ""
   if trim(cod_cpf)<>"" then
      cod_cpf = Replace(Replace(cod_cpf,".",""),"-","")
      for i=len(cod_cpf) to 10
      cod_cpf = "0" & cod_cpf
      next
      sAux = left(cod_cpf,3) & "."
      sAux = sAux & mid(cod_cpf,4,3) & "."
      sAux = sAux & mid(cod_cpf,7,3) & "-"
      sAux = sAux & right(cod_cpf,2)
      FormataCPF = sAux
   end if
end function
'------------------------------------------------------------------------------------------
function FormataCGC(pCNPJ)
   dim I
   if trim(pCNPJ) <> "" then
      if len(pCNPJ)<14 then
         for I = len(pCNPJ)+1 to 14
            pCNPJ = "0" & pCNPJ
         next
      end if
   end if
    FormataCGC = ""
   if trim(pCNPJ)<>"" then
      FormataCGC = left(pCNPJ,2) & "."
      FormataCGC = FormataCGC & mid(pCNPJ,3,3) & "."
      FormataCGC = FormataCGC & mid(pCNPJ,6,3) & "/"
      FormataCGC = FormataCGC & mid(pCNPJ,9,4) & "-"
      FormataCGC = FormataCGC & right(pCNPJ,2)
   end if
end function
'------------------------------------------------------------------------------------------
function montaCombo(rsCombo, nome, valor, onChange, txtReadOnly)

   dim strCombo

   strCombo = ""

   strCombo = "<select name='" & nome & "' onchange='" & onChange & "' tabindex=1 " & txtReadOnly & ">"
   strCombo = strCombo & "<option></option>" & Chr(13) & Chr(10)
   do while not rsCombo.eof
      if cstr(valor) = cstr(rsCombo(0)) then
         strCombo = strCombo & "<option value=" & rsCombo(0) & " selected>" & rsCombo(1) & "</option>" & Chr(13) & Chr(10)
      else
         strCombo = strCombo & "<option value=" & rsCombo(0) & ">" & rsCombo(1) & "</option>" & Chr(13) & Chr(10)
      end if
      rsCombo.movenext
   loop

   strCombo = strCombo & "</select>" & Chr(13) & Chr(10)
   montaCombo = strCombo
end function
'------------------------------------------------------------------------------------------
function retornaCursor(p_nome_tabela, p_campo_value, p_campo_desc, p_where, p_order)
   '-----------------------------------------------------------------------
   'Montar combo da situação das prévias
   '-----------------------------------------------------------------------
   Dim rsCombo
   Dim VetCombo(5,4)

   VetCombo(1, 1) = "IN"
   VetCombo(1, 2) = "adVarChar"
   VetCombo(1, 3) = "p_nome_tabela"
   VetCombo(1, 4) = p_nome_tabela

   VetCombo(2, 1) = "IN"
   VetCombo(2, 2) = "adVarChar"
   VetCombo(2, 3) = "p_campo_value"
   VetCombo(2, 4) = p_campo_value

   VetCombo(3, 1) = "IN"
   VetCombo(3, 2) = "adVarChar"
   VetCombo(3, 3) = "p_campo_desc"
   VetCombo(3, 4) = p_campo_desc

   VetCombo(4, 1) = "IN"
   VetCombo(4, 2) = "adVarChar"
   VetCombo(4, 3) = "p_order"
   VetCombo(4, 4) = p_order

   VetCombo(5, 1) = "IN"
   VetCombo(5, 2) = "adVarChar"
   VetCombo(5, 3) = "p_where"
   VetCombo(5, 4) = p_where

   Set rsCombo =  rsCursorOracle (   CStr(Session("ace_usuario")),_
                           CStr(Session("ace_senha")),_
                           CStr(Session("ace_ip")),_
                           CStr(Session("ace_sistema")),_
                           CStr(Session("ace_modulo")),_
                           "RB_PREVIA_REEMBOLSO.RetornaCursor", _
                           VetCombo, _
                           false )


   FechaConexao()

   set retornaCursor = rsCombo
end function

'------------------------------------------------------------------------------------------
function retornaFiliais()
   '-----------------------------------------------------------------------
   'Montar combo da situação das prévias
   '-----------------------------------------------------------------------
   Dim rsCombo
   Dim VetCombo(3,4)

   VetCombo(1, 1) = "OUT"
   VetCombo(1, 2) = "adVarChar"
   VetCombo(1, 3) = "p_cod_retorno"

   VetCombo(2, 1) = "OUT"
   VetCombo(2, 2) = "adVarChar"
   VetCombo(2, 3) = "p_msg_retorno"

   VetCombo(3, 1) = "IN"
   VetCombo(3, 2) = "adVarChar"
   VetCombo(3, 3) = "p_cod_usuario"
   VetCombo(3, 4) = CStr(Session("ace_usuario"))

   Set rsCombo =  rsCursorOracle (   CStr(Session("ace_usuario")),_
                           CStr(Session("ace_senha")),_
                           CStr(Session("ace_ip")),_
                           CStr(Session("ace_sistema")),_
                           CStr(Session("ace_modulo")),_
                           "RB_PREVIA_REEMBOLSO.get_filial_unidade", _
                           VetCombo, _
                           false )


   FechaConexao()

   set retornaFiliais = rsCombo
end function
'------------------------------------------------------------------------------------------
Sub MontaInformacao()%>
   <table id="tbPrevia" width="100%" align="center" border="0">
      <!-- DADOS DA PREVIA -->
      <tr>
         <td width:="15%" nowrap class="label_right">Data Solicitação&nbsp;</td>
         <td nowrap colspan="3">
            <input type="text" name="dt_solicitacao"   value="<%=dt_inclusao_pedido%>" readonly class=camposblocks>
         </td>
      </tr>

      <tr>
         <td nowrap class="label_right">Origem da solicitação&nbsp;</td>
         <td nowrap colspan="3">
            <%
            set rsCombo = retornaCursor("origem_reembolso","cod_origem","nome_origem"," where ind_simulacao = 'S' and ind_visibilidade in ('A','"& ind_visibilidade &"') ", "order by nome_origem")
            response.write montaCombo(rsCombo, "cod_origem", cod_origem, "", txt_disabled_cam)
            %>
         </td>
      </tr>

      <tr>
         <td nowrap class="label_right">Modalidade do reembolso&nbsp;</td>
         <td nowrap colspan="3">
            <%
            set rsCombo = retornaCursor("tipo_reembolso","ind_tipo_reembolso","nome_tipo_reembolso","", "order by ind_tipo_reembolso")
            response.write montaCombo(rsCombo, "ind_tipo_reembolso", ind_tipo_reembolso, "atualizaTipoReemolso(""S"")", txt_disabled)
            %>
            <input type="hidden" name="ind_tipo_reembolso_old" id="ind_tipo_reembolso_old" value="<%=ind_tipo_reembolso%>">
         </td>
      </tr>

      <tr>
         <td nowrap class="label_right">
            Motivo Reembolso&nbsp;
            <input type="hidden" name="cod_motivo_reembolso_old" id="cod_motivo_reembolso_old" value="<%=cod_motivo_reembolso%>">
         </td>
         <td nowrap colspan="3" id="tdMotivoReembolso">
            <%
            set rsCombo = retornaCursor("motivo_reembolso","cod_motivo_reembolso","desc_motivo_reembolso"," where ind_ativo = 'S'"&sWhereMotivo, "order by desc_motivo_reembolso")
            response.write montaCombo(rsCombo, "cod_motivo_reembolso", cod_motivo_reembolso, "alteraCarater();validaMotivo();", txt_disabled)
            %>
         </td>
      </tr>

      <tr>
         <td nowrap class="label_right">Filial / Unidade da abertura&nbsp;</td>
         <td nowrap colspan="3">
            <%
            set rsCombo = retornaFiliais
            response.write montaCombo(rsCombo, "cod_inspetoria_ts_abertura", cod_inspetoria_ts_abertura, "atualizaPrazo(this.value)", txt_disabled)
            %>
         </td>
      </tr>
      <tr>
         <td nowrap class="label_right">Prazo análise&nbsp;</td>
         <td nowrap colspan="3">
            <input type="text" name="qtd_dias_reemb_uteis" value="<%=qtd_dias_reemb_uteis %>" size="3" maxlength="3" readonly class=camposblocks /> dias úteis
            <input type="hidden" name="qtd_dias_reembolso" value="<%=qtd_dias_reembolso %>" size="3" maxlength="3" />
         </td>
      </tr>
      <tr>
         <td nowrap class="label_right">Data provável de análise&nbsp;</td>
         <td nowrap colspan="3">
            <input type="text" name="dt_provavel_reembolso" value="<%=dt_provavel_reembolso%>" size="12" maxlength="3" readonly class=camposblocks />
         </td>
      </tr>

	  <!--ATENDIMENTO -->
	  <td colspan = "4">
         <table width="100%" border="0" id="tb_dv_atendimento">
            <tr>
               <td class="grid_cabec" width="98%"><h1 class="grid_cabec"><label><font align="center" class="label_left"><b>&nbsp;Atendimento</b></label></h1></td>
               <td class="label_right" ><h1 class="grid_cabec"><img id="img_dv_atendimento" src="../../gen/img/btn-dn.jpg" width="16" height="12" onClick="Expandir('dv_atendimento');" style="cursor:hand" title="Clique para exibir atendimento" /></h1></td>
            </tr>
         </table>
         <div id="dv_atendimento"><fieldset><% Call MontaAtendimento() %></fieldset></div>
	  </td>

      <!--EXECUTANTE-->
      <tr style="display:none;">
         <td colspan="4">
            <fieldset>
               <legend><b>Executante</b></legend>
               <table border="0" width="100%" align="center">
                  <tr>
                     <td class="label_right" width="30%">
                     &nbsp;
                     </td>
                     <td class="label_left">
                        <input type="radio" name="ind_insc_fiscal" value="F" onclick="ExibeInscricaoFiscal();" <%if ind_insc_fiscal = "F" or ind_insc_fiscal = "" then%> checked <%end if%> >&nbsp;CPF&nbsp;&nbsp;
                        <input type="radio" name="ind_insc_fiscal" value="J" onclick="ExibeInscricaoFiscal();" <%if ind_insc_fiscal = "J" then%> checked <%end if%> >&nbsp;CNPJ
                        &nbsp;&nbsp;
                        Inscrição&nbsp;
                        <input type="text" name="num_cpf" value="<%=num_insc_fiscal%>" size="16" maxlength="14" onKeypress='javascript:MascCpf();' OnKeyDown="TeclaEnter();" onChange="javascript:CarregaExecutante('1');"  tabindex="1" >
                        <input type="text" name="num_cnpj" value="<%=num_insc_fiscal%>" size="16" maxlength="18" tabindex="1" onKeyPress="MascCgc();" OnKeyDown="TeclaEnter();" style="display:none" >
                        <img style="cursor:hand" id="imgPesqExecutante" name="imgPesqExecutante" width="16" height="16" src="/gen/mid/lupa.gif" border="0" Title="Pesquisar Executante" onClick="javascript:PesquisaExecutante('C');" >
                     </td>
                  </tr>
                  <tr>
                     <td class="label_right">
                        &nbsp;&nbsp;Nome&nbsp;
                     </td>
                     <td class="label_left">
                        <input type="text" name="nome_prestador" value="<%=nome_prestador%>" size="45" maxlength="50" onKeypress='javascript:MascAlfaNum();'  OnKeyDown=TeclaEnter() tabindex="1" >
                     </td>
                  </tr>
                  <tr>
                     <td class="label_right">Conselho&nbsp;</td>
                     <td colspan="2" class="label_left">
                        <%
                        set rsCombo = retornaCursor("CONSELHO_REGIONAL","SIGLA_CONSELHO SIGLA_CONSELHO_1","SIGLA_CONSELHO","", "order by SIGLA_CONSELHO")
                        response.write montaCombo(rsCombo, "sigla_conselho", sigla_conselho, "", "")
                        %>
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        Nº&nbsp;
                        <input type="text" name="num_crm" value="<%=num_crm%>" size="15" maxlength="10" onKeypress='javascript:MascInt();' OnKeyDown=TeclaEnter(); tabindex="1" onchange="CarregaExecutante('2');">
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        UF&nbsp;
                        <%
                        set rsCombo = retornaCursor("UNIDADE_FEDERACAO","SGL_UF SGL_UF_1","SGL_UF","", "order by SGL_UF")
                        response.write montaCombo(rsCombo, "uf_conselho", uf_conselho, "", "")
                        %>
                     </td>
                  </tr>
                  <tr>
                     <td class="label_right">Nº CNES&nbsp;</td>
                     <td colspan="2" class="label_left">
                        <input type="text" name="cnes" value="<%=cnes%>" size="8" tabindex="1" maxlength="7" OnKeyDown="TeclaEnter()" onKeyPress ="javascript:MascInt()" >                        &nbsp;&nbsp;&nbsp;&nbsp;
                        CBO-s&nbsp;
                        <input type="text" name="cod_cbo" value="<%=cod_cbo%>" size="" tabindex="1" maxlength="6" OnKeyDown="TeclaEnter()" onKeyPress ="javascript:MascInt()" onchange="CarregaCBO();" >
                        <%
                           'if trim(num_reembolso) = "" then
                              set oPesquisa = Server.CreateObject("TSACE0090.PESQUISA")
                              oPesquisa.PesqNome = "img_cbo_1"
                              oPesquisa.TituloPesquisa = "Pesquisar CBO"
                              oPesquisa.CodCampo = "cod_cbo"
                              oPesquisa.NomCampo = "nome_cbo"
                              oPesquisa.indsubmit = false
                              oPesquisa.Tabela = "CBO_S"
                              oPesquisa.NomCampoDisplay = "nome_cbo"
                              oPesquisa.CodCampoDisplay = "cod_cbo"
                              CALL oPesquisa.MontaPesquisa2()
                              set oPesquisa = nothing
                           'end if
                        %>
                        <input type="text" name="nome_cbo" value="<%=nome_cbo%>" size="45" readonly class="camposblocks">
                     </td>
                  </tr>
               </table>
            </fieldset>
         </td>
      </tr>
	  <!--ANEXO -->
			<td colspan = "4">
            <table width="100%" border="0" id="tb_dv_anexo">
               <tr>
                  <td class="grid_cabec" width="98%"><h1 class="grid_cabec"><label><font align="center" class="label_left"><b>&nbsp;Anexos</b></label></h1></td>
                  <td class="label_right" ><h1 class="grid_cabec"><img id="img_dv_anexo" src="../../gen/img/btn-dn.jpg" width="16" height="12" onClick="Expandir('dv_anexo');" style="cursor:hand" title="Clique para exibir Anexos" /></h1></td>
               </tr>
            </table>
            <div id="dv_anexo" style='display:none'><fieldset><% Call MontaAnexo() %></fieldset></div>
			</td>
			
	<!--Teste DATA ORÇAMENTO -->
	<tr>
         <td colspan="4">
		  <fieldset>
		    <legend><b>Dados Orçamento</b></legend>
			 <table border="0" width="100%" align="center">
				&nbsp;&nbsp;Data Orçamento
				<input name="dt_comprovante" size="12" maxlength="10"  value="<%=dt_comprovante%>"  tabindex="0" onKeyPress ="MascData('dd/mm/yyyy')" onchange="CalculaValorEmReais()" <%if ind_forma_abertura = "HI" then%>Readonly class="camposblocks"<%end if%> />

				<% if bTelaDesabilitada = false then %>
				    <% Call MontaCalendario("dt_comprovante")%>
				<% end if %>
				 &nbsp;&nbsp;Valor Solicitado
				<input type="text" name="val_moeda_estrangeira" value="<%=val_moeda_estrangeira%>" size="8" maxlength="10" onKeyPress="javascript:MascNum2()"  tabindex="0" style="TEXT-ALIGN: right" onchange="CalculaValorEmReais()" <%if ind_forma_abertura = "HI" then%>Readonly class="camposblocks"<%end if%> />
				
				 &nbsp;&nbsp;Moeda
				<span id="dvMoeda">
				    <%
				    if ind_internacional = "S" then
				        set rsCombo = retornaCursor("moeda","sigla_moeda","sigla_moeda sigla_moeda2"," where nvl(ind_unidade_padrao,'N') = 'S' or nvl(ind_moeda_estrangeira,'N') = 'S'", "order by sigla_moeda") 
				    else
					                set rsCombo = retornaCursor("moeda","sigla_moeda","sigla_moeda sigla_moeda2"," where nvl(ind_unidade_padrao,'N') = 'S'", "order by sigla_moeda") 
					            end if
					            response.write montaCombo(rsCombo, "sigla_moeda", sigla_moeda, "CalculaValorEmReais()", desabilitadoCRTHist)
				    %>
				</span>				
				<span id="dvValInformado" style="display:<%if ind_internacional <> "S" then response.write "none"%>">
                                &nbsp;&nbsp;Valor
				    <input type="text" name="val_comprovante" value="<%=val_comprovante%>" size="8" maxlength="10" onKeyPress="javascript:MascNum2()"  tabindex="0" style="TEXT-ALIGN: right" readonly class="camposblocks" <%if ind_forma_abertura = "HI" then%>Readonly class="camposblocks"<%end if%> />
				</span>
				</table>
			</fieldset>
		</td>
	</tr>
      <tr>
         <td colspan="4">
            <fieldset>
               <legend><b>Tipo emissão</b></legend>
               <table border="0" width="100%" align="center">
                  <tr style="display:<% if bAcessoOperadora = false then response.write "none"%>">
                     <td width="30%" class="label_right">&nbsp;</td>
                     <td class="label_left">
                        <input type="radio" name="ind_tipo_emissao" value="E" <%if ind_tipo_emissao = "E" then%> checked <% end if %> tabindex="1" >&nbsp;E-mail &nbsp;&nbsp;
                        <input type="radio" name="ind_tipo_emissao" value="F" <%if ind_tipo_emissao = "F" then%> checked <% end if %> tabindex="1" >&nbsp;Fax &nbsp;&nbsp;
                        <input type="radio" name="ind_tipo_emissao" value="I"  <%if ind_tipo_emissao = "I" or ind_tipo_emissao = "" then%> checked <% end if %> tabindex="1" >&nbsp;Impressão
                     </td>
                   </tr>
               </table>
            </fieldset>
         </td>
      </tr>

      <tr>
         <td class="label_right" nowrap>Observação&nbsp;</td>
         <td colspan="3">
            <textarea name="txt_observacao" rows="4" cols="90" tabindex="1" onKeyUp="ContarTexto(this, 4000, 'qtd_caracteres_1')" ><%=txt_observacao%></textarea>
            <div id="qtd_caracteres_1" class="label_left"><%=Cint(4000)-Cint(Len(txt_observacao&""))%> caracteres restantes</div>
         </td>
      </tr>

      <tr>
         <td class="label_right" nowrap>Observação Operadora&nbsp;</td>
         <td colspan="3">
            <textarea name="txt_observacao_operadora" rows="4" cols="90" tabindex="1" onKeyUp="ContarTexto(this, 4000, 'qtd_caracteres_2')" ><%=txt_observacao_operadora%></textarea>
            <div id="qtd_caracteres_2" class="label_left"><%=Cint(4000)-Cint(Len(txt_observacao_operadora&""))%> caracteres restantes</div>
         </td>
      </tr>

       <tr>
         <td colspan="2" class="label_right">&nbsp;</td>
      </tr>
	  
	  	<!--SOLICITANTE-->
		<tr>
			<td colspan="4">
				<fieldset>
					<legend><b>Solicitante</b></legend>
					<table border="0" width="100%" align="center">
						<tr>
							<input type="hidden" name="cod_solicitante" value="<%=cod_solicitante%>" />
							<td class="label_right" width="20%">&nbsp;</td>
							<td class="label_left">												
								<input type="radio" name="ind_insc_fiscal_solicitante" value="F" onclick="ExibeInscricaoFiscal('S');" <%if ind_insc_fiscal_solicitante = "F" or ind_insc_fiscal_solicitante = "" then%> checked <%end if%>  tabindex="0" <%if ind_forma_abertura = "HI" then%>disabled="disabled" class="camposblocks"<%end if%> />&nbsp;CPF&nbsp;&nbsp;
								<input type="radio" name="ind_insc_fiscal_solicitante" value="J" onclick="ExibeInscricaoFiscal('S');" <%if ind_insc_fiscal_solicitante = "J" then%> checked <%end if%>  tabindex="0" <%if ind_forma_abertura = "HI" then%>disabled="disabled" class="camposblocks"<%end if%> />&nbsp;CNPJ
								&nbsp;&nbsp;
								Inscrição&nbsp;
								<input type="text" name="num_cpf_solicitante" value="<%=num_insc_fiscal_solicitante%>" size="16" maxlength="14" onKeypress='javascript:MascCpf();' OnKeyDown="TeclaEnter();" onBlur="ValidaInscricao(this, 'S');" tabindex="0" <%if ind_forma_abertura = "HI" then%>Readonly class="camposblocks"<%end if%> />
								<input type="text" name="num_cnpj_solicitante" value="<%=num_insc_fiscal_solicitante%>" size="16" maxlength="18"  tabindex="0" onKeyPress="MascCgc();" OnKeyDown="TeclaEnter();" onBlur="ValidaInscricao(this, 'S');" style="display:none" <%if ind_forma_abertura = "HI" then%>Readonly class="camposblocks"<%end if%> />
								
								<% if bTelaDesabilitada = false or nome_prestador_solicitante = "" then %>
                                        <img style="cursor:hand" id="imgPesqExecutante" name="imgPesqExecutante" width="16" height="16" src="/gen/mid/lupa.gif" border="0" title="Pesquisar Solicitante" onClick="javascript:PesquisaSolicitante('C');" >								
								<% end if %>
												
							</td>
						</tr>
						<tr>
							<td class="label_right">&nbsp;&nbsp;Nome&nbsp;</td>
							<td class="label_left">
								<input type="text" name="nome_prestador_solicitante" value="<%=nome_prestador_solicitante%>" size="45" maxlength="50" onKeypress='javascript:MascAlfaNum();'  OnKeyDown=TeclaEnter()  tabindex="0" <%if ind_forma_abertura = "HI" then%>Readonly class="camposblocks"<%end if%> />&nbsp;
							</td>
						</tr>
						<tr>
							<td class="label_right">Conselho&nbsp;</td>
							<td colspan="2" class="label_left">
								<%
								set rsCombo = retornaCursor("CONSELHO_REGIONAL","SIGLA_CONSELHO SIGLA_CONSELHO_1","SIGLA_CONSELHO","", "order by SIGLA_CONSELHO") 
								response.write montaCombo(rsCombo, "sigla_conselho_solicitante", sigla_conselho_solicitante, "", desabilitadoCRTHist)				
								%>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Nº&nbsp;
								<input type="text" name="num_crm_solicitante" value="<%=num_crm_solicitante%>" size="15" maxlength="10" onKeypress='javascript:MascInt();' OnKeyDown=TeclaEnter();  tabindex="0" onchange="CarregaExecutante('2', 'S');" <%if ind_forma_abertura = "HI" then%>Readonly class="camposblocks"<%end if%> />
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;UF&nbsp;
								<%
								set rsCombo = retornaCursor("UNIDADE_FEDERACAO","SGL_UF SGL_UF_1","SGL_UF","", "order by SGL_UF") 
								response.write montaCombo(rsCombo, "uf_conselho_solicitante", uf_conselho_solicitante, "", desabilitadoCRTHist)				
								%>
							</td>
						</tr>
						<tr>
							<td class="label_right">Nº CNES&nbsp;</td>
							<td colspan="2" class="label_left">
								<input type="text" name="cnes_solicitante" id="cnes_solicitante" value="<%=cnes_solicitante%>" size="8"  tabindex="0" maxlength="7" OnKeyDown="TeclaEnter()" onKeyPress ="javascript:MascInt()" <%if ind_forma_abertura = "HI" then%>Readonly class="camposblocks"<%end if%> / > &nbsp;&nbsp;&nbsp;&nbsp;
								CBO-s&nbsp;
								<input type="text" name="cod_cbo_solicitante" value="<%=cod_cbo_solicitante%>" size="5"  tabindex="0" maxlength="6" OnKeyDown="TeclaEnter()" onKeyPress ="javascript:MascInt()" onchange="CarregaCBOSolicitante();" <%if ind_forma_abertura = "HI" then%>Readonly class="camposblocks"<%end if%> />
                                <img style="display:<%if ind_forma_abertura = "HI" then%>none"<%end if%>; cursor:hand" name="img_cbo_1" width="16" height="16" src="/gen/mid/lupa.gif" border="0" title="Pesquisar CBO" onclick="AbrePesquisaCrossBrowser('/ACE/ASP/ACE0090a_crossbrowser.asp?nomcampo=nome_cbo&amp;nomcampodisplay=nome_cbo_solicitante&amp;nomcampolabel=&amp;nome=&amp;indsubmit=False&amp;codcampodisplay=cod_cbo_solicitante&amp;codcampolabel=&amp;codcampo=cod_cbo&amp;PesqNome=img_cbo_1&amp;tabela=CBO_S&amp;titulopesquisa=Pesquisar CBO&amp;txtWhere=&amp;txtOrder=&amp;txtFuncao=','img_cbo_1','Pesquisar CBO',500,300,100,100,'S')" />
								<input type="text" name="nome_cbo_solicitante"  value="<%=nome_cbo_solicitante%>" tabindex="0" size="45" readonly class="camposblocks">
							</td>
						</tr>
					</table>
				</fieldset>   
			</td>
		</tr>
   </table>
<%end sub
Sub MontaAtendimento()%>
	<table id="tbAtendimento" width="100%" align="center" border="0">		
		<!-- DADOS DA REEMBOLSO -->
		<tr>
			<td width="22%" class="label_right">Tipo Atendimento / Internação&nbsp;</td>
			<td nowrap colspan="3" id="tdTipoAtendimento">
				<%
                
				if ind_forma_abertura <> "IN" then
					set rsCombo = retornaCursor("tipo_tratamento","cod_tratamento","nome_tratamento",sWhereAtendimento, "order by ordem_apresentacao") 
				
					response.write montaCombo(rsCombo, "cod_tratamento", cod_tratamento, "atualizaDadosTipoAtendimento()", "")
				else
				%>
					<select name="cod_tratamento"  tabindex="0">
						<option></option>
					</select>
					
				<%
				end if
				%> 

			</td>
		</tr>
		<tr id="trCarater" style="display:">
         <td class="label_right">
            Caráter&nbsp;
         </td>
         <td colspan="2">
            <input type="radio" name="ind_carater_rd" value="E" tabindex="1" <%if ind_carater = "E" then%> checked <%end if%> onClick="gravaCarater();" disabled >
            <font class="label_right">&nbsp;Eletivo</font>&nbsp;&nbsp;&nbsp;
            <input type="radio" name="ind_carater_rd" value="U" tabindex="1" <%if ind_carater = "U" then%> checked <%end if%> onClick="gravaCarater();" disabled >
            <font class="label_right">&nbsp;Urgência / Emergência</font>
            <input type="hidden" name="ind_carater" value="<%=ind_carater%>">
         </td>
      </tr>
	  
		<tr>
         <td class="label_right" nowrap>Autorização&nbsp;</td>
         <td colspan="3" nowrap>
            <input type="text" name="num_internacao" value="<%=num_internacao%>" size="15" tabindex="1" maxlength="10" OnKeyDown="TeclaEnter();" onKeyPress="javascript:MascInt();" onchange="CarregaAutorizacao();">

                <% if ind_forma_abertura = "IN" or ind_forma_abertura = "AL" then %>
                <img id='Pesquisa_Pedido' style='cursor:hand' name='Pesquisa_Pedido' width='16' height='16' src='/gen/mid/lupa.gif' border='0' Title='Pesquisar Pedido de Autorização' onClick="javascript:AbrePesquisaAutorizacao();">
                <a href="javascript:HistoricoPedido();" <% if num_internacao = "" then response.write "style='display:none'"%> name="historico_aut" id="historico_aut"><img src="../../gen/img/folha2.gif" border="0" Title="Detalhes do pedido" ></a>
                <% end if %>

         </td>
      </tr>      

      <tr id="trAcomodacao" style="display:<% if cod_acomodacao = "" then response.write "none" %>">
         <td nowrap class="label_right">Tipo Acomodação&nbsp;</td>
         <td nowrap colspan="3">
		 	<%
			set rsCombo = retornaCursor("tipo_acomodacao","cod_acomodacao","nome_acomodacao","", "order by nome_acomodacao") 
			response.write montaCombo(rsCombo, "cod_acomodacao", cod_acomodacao, "atualizaIndAcomodacao()", "")				
			%>			 				
			<input type="hidden" name="ind_acomodacao" id="ind_acomodacao" value="<%=ind_acomodacao%>" />
		</td>
		 
	</table>
<%end sub
Sub MontaAnexo()
    Dim oXML, oRegXML, k, msg_anexo
    dim qtd_anexo
    qtd_anexo = 0

    Set oXML = CreateObject("Microsoft.XMLDOM")
    oXML.async = False
    oXML.loadXML(xml_anexo)
    Set oRegXML = oXML.getElementsByTagName("DADOS")
    %>
    <table border="0" width="95%" align="center" id="tbAnexo">
        <tr>
		 <td width="15%" class="grid_cabec" align=center><b>Data</b></td>
         <td width="55%" class="grid_cabec" align=center><b>Descrição</b></td>
		 <td width="15%" class="grid_cabec" align=center><b>Documento Original?</b></td>
            <td width="10%" class="grid_cabec" align=center><b>Anexo</b></td>
            <td width="05%" class="grid_cabec" align=center><b>Excluir</b></td>
        </tr>
        <%
        Dim strPath, strFileName
        For k = 0 To oRegXML.Length - 1
            if oRegXML.Item(k).selectSingleNode("./COD_RETORNO").Text = "0" then
                strPath = oRegXML.Item(k).selectSingleNode("./NOM_ARQ_ANEXO").Text
                strFileName = Mid(strPath, InStrRev(strPath, "\") + 1)
                %>
                <tr>
				 <td class='grid_left'>&nbsp;
                         <%  
                      response.write oRegXML.Item(k).selectSingleNode("./DT_ANEXADO").Text
                      %>

                   </td>
                   <td class='grid_left'>
                      <%
                      'Response.Write left(oRegXML.Item(k).selectSingleNode("./TXT_DESCRICAO").Text, 25)

                      'if len(oRegXML.Item(k).selectSingleNode("./TXT_DESCRICAO").Text) > 25 then
                      '   msg_anexo = ""
                      '   msg_anexo = oRegXML.Item(k).selectSingleNode("./TXT_DESCRICAO").Text
                      '   msg_anexo = replace(msg_anexo, "'", "\'")
                      '   msg_anexo = replace(msg_anexo, chr(13), "")
                      '   msg_anexo = replace(msg_anexo, chr(10), "<br>")
                         %>
                         <!--img Title="Clique para ver o texto completo." SRC="\gen\img\folha_1.gif" onclick="mostra_detalhe_anexo('<%=msg_anexo%>')" style="cursor:'hand'"-->&nbsp;
                         <%
                      'end if

                      response.write oRegXML.Item(k).selectSingleNode("./TXT_DESCRICAO").Text
                      %>

                   </td>
				    <td class='grid_center' nowrap ">
                         <%  
                      response.write oRegXML.Item(k).selectSingleNode("./IND_NOTA_ORIGINAL").Text
                      %>

                   </td>
                   <td class='grid_center' nowrap>
                      <%if oRegXML.Item(k).selectSingleNode("./NOM_ARQ_ANEXO").Text & "" <> "" then%>
                                <input type="hidden" name="nome_arquivo_<%=k+1%>" value="<%=CStr(oRegXML.Item(k).selectSingleNode("./NOM_ARQ_ANEXO").Text)%>"/>
                               <a onclick="AlteraIcone(<%=k+1%>);"  target=_blank href="<%=oRegXML.Item(k).selectSingleNode("./NOM_ARQ_ANEXO").Text%>" title="<%=strFileName%>"><img id="clips_<%=k+1%>" border=0 src="\gen\img\clips_1.gif"></a>
								
                      <%else%>
                         <input type="hidden" name="nome_arquivo_<%=k+1%>" value="<%=CStr(oRegXML.Item(k).selectSingleNode("./NOM_ARQ_ANEXO").Text)%>" />
                         &nbsp;
                      <%end if%>
                   </td>
                   <!--td class='grid_center' nowrap><%=oRegXML.Item(k).selectSingleNode("./COD_USUARIO").Text%></td-->
                   <td class='grid_center'>
                      <center><input type="checkbox" name="ind_excluir_anexo_<%=k+1%>" id="ind_excluir_anexo_<%=k+1%>" value="S"></center>
                      <input type="hidden" name="ind_alterar_<%=k+1%>" id="ind_alterar_<%=k+1%>" value="S">
                   </td>
                </tr>
                <%
                qtd_anexo = qtd_anexo + 1
            end if
        next
        Set oXML = Nothing
        Set oRegXML = Nothing
        %>
        <br />
    </table>
    <center><input class="informacao" id="btnAnexo" type="button" onclick="AdicionarAnexo();" value="Adicionar Anexo" style="cursor:hand" tabindex="1"></center>
    <input type="hidden" name="qtd_anexo" value="<%=qtd_anexo%>">
<%end sub
'-------------------------------------------------------------------------
' Montar grid das Ocorrências
'-------------------------------------------------------------------------
Sub MontaOcorrencia()
   Dim oXML, oRegXML, x

   Set oXML = CreateObject("Microsoft.XMLDOM")
   oXML.async = False
   oXML.loadXML(xml_ocorrencia)
   Set oRegXML = oXML.getElementsByTagName("DADOS")
   %>
   <table border="0" width="98%" align="center">
      <tr>
         <td width="05%" class="grid_cabec" align=center><b>Data</td>
         <td width="05%" class="grid_cabec" align=center><b>Descrição</td>
         <td width="05%" class="grid_cabec" align=center><b>Usuário</td>
         <td width="05%" class="grid_cabec" align=center><b>Observação</td>
         <td width="05%" class="grid_cabec" align=center><b>Observação Operadora</td>
      </tr>
      <%For x = 0 To oRegXML.Length - 1 %>
         <tr>
            <td class='grid_center' nowrap><%=oRegXML.Item(x).selectSingleNode("./DT_OCORRENCIA").Text%></td>
            <td class='grid_left' nowrap><%=oRegXML.Item(x).selectSingleNode("./NOM_TIPO_OCORRENCIA").Text%></td>
            <td class='grid_center' nowrap title="<%=oRegXML.Item(x).selectSingleNode("./NOM_USUARIO").Text%>"><%=oRegXML.Item(x).selectSingleNode("./COD_USUARIO").Text%></td>
            <td class='grid_left' ><%=oRegXML.Item(x).selectSingleNode("./TXT_OBS").Text%></td>
            <td class='grid_left' ><%=oRegXML.Item(x).selectSingleNode("./TXT_OBS_PREVIA").Text%></td>
         </tr>
      <%next
      Set oXML = Nothing
      Set oRegXML = Nothing
      %>
   </table>
   <%
End Sub
'---------------------------
Sub MontaProcedimento()%>
   <div id="DvProcedimento" class="label_center">
      <table border="0" width="98%" align="center" id="TbProcedimento">
         <tr>
            <td width="05%" class="grid_cabec" align=center><b>Código</td>
            <!--td width="05%" class="grid_cabec" align=center><b>Código Procedimento</td-->
            <td width="10%" class="grid_cabec" align=center><b>Descrição</td>
			<td width="05%" class="grid_cabec" align=center><b>Cobertura</b></td>
			<td width="05%" class="grid_cabec" align=center><b>Diretriz</b></td>
			<td width="05%" class="grid_cabec" align=center><b>Genética</b></td>
			<td width="05%" class="grid_cabec" align=center><b>G.E.</b></td>
            <td width="05%" class="grid_cabec" align=center nowrap><b>Paga em<BR>dobro?</td>
            <td width="05%" class="grid_cabec" align=center nowrap><b>Adiciona<BR>anestesista?</td>
            <td width="05%" class="grid_cabec" align=center><b>Memória<BR>Cálculo</td>
            <td width="05%" class="grid_cabec" align=center><b>Qtd.</td>
            <td width="05%" class="grid_cabec" align=center style="display:none"><b>Situação</td>
            <td width="05%" class="grid_cabec" align=center><b>Principal?</td>
            <td width="05%" class="grid_cabec" align=center><b>Via de Acesso</td>
            <td width="05%" class="grid_cabec" align=center><b>Tipo de Doppler</td>
            <td width="05%" class="grid_cabec" align=center nowrap><b>Valor<BR>Apresentado (R$)</td>
            <td width="05%" class="grid_cabec" align=center nowrap><b>Valor<BR>Calculado (R$)</td>
            <td width="05%" class="grid_cabec" align=center nowrap><b>Valor<BR>reembolsado (R$)</td>
            <td width="05%" class="grid_cabec" align=center nowrap><b>Desconto de<BR>coparticipação (R$)</td>
            <td width="05%" class="grid_cabec" align="center"><b>Excluir</b></td>
            <td width="10%" class="grid_cabec" align="center"id="td_especialidade_head"><b>Especialidade</b></td>
         </tr>
      <%
         qtd_procedimento = "0"
         if trim(num_reembolso) <> "" AND ind_forma_abertura <> "IN" and xml_procedimento <> "" then
            qtd_procedimento = CarregaProcedimentos(xml_procedimento)
         end if
      %>
      </table>
      <br />
      <table border="0" width="50%" align="center" ID="tb_adiciona_procedimento">
         <tr>
            <td align=left>
               <input class=informacao type="button" onclick="IncluirProcedimento('S')" value="Adicionar Procedimento/Serviço" name=button2 style="cursor:hand">
            </td>
         </tr>
      </table>
   </div>
   <input type="hidden" name="qtd_procedimento" value="<%=qtd_procedimento%>">
<%End Sub

Function CarregaProcedimentos(pXMLProcedimentos)
   Dim oXMLItem, oRegItemXML, x, qtd_glosa_item, sIndPrincipal, sIndSituacao
   dim qtd_funcoes, i, cod_procedimento_cm, cod_procedimento
   dim qtd_glosa_analisada, qtd_glosa_analise
   dim rsCombo
   dim ind_rol_procedimentos, ind_diretriz, ind_genetica,imgCobertura, imgDiretriz, imgGenetica

   Set oXMLItem = CreateObject("Microsoft.XMLDOM")
   oXMLItem.async = False
   oXMLItem.loadXML(pXMLProcedimentos)
   Set oRegItemXML = oXMLItem.getElementsByTagName("DADOS")

   For x = 0 To oRegItemXML.Length - 1
   
		 imgCobertura = ""
		 imgDiretriz	 = ""
		 imgGenetica	 = ""
		
         qtd_funcoes = oRegItemXML.Item(x).selectSingleNode("./QTD_FUNCOES").Text
         sIndPrincipal = oRegItemXML.Item(x).selectSingleNode("./IND_PRINCIPAL").Text
         sIndSituacao = oRegItemXML.Item(x).selectSingleNode("./IND_SITUACAO").Text
         set xml_funcoes  = oRegItemXML.Item(x).selectSingleNode("./FUNCOES")

         num_seq_itens_proc = ""

         cod_procedimento_cm = oRegItemXML.Item(x).selectSingleNode("./COD_PROCEDIMENTO_CM").Text
         cod_procedimento      = oRegItemXML.Item(x).selectSingleNode("./COD_PROCEDIMENTO").Text
		 ind_rol_procedimentos   = oRegItemXML.Item(x).selectSingleNode("./IND_ROL_PROCEDIMENTOS").Text
		 ind_diretriz		    = oRegItemXML.Item(x).selectSingleNode("./IND_DIRETRIZ").Text
		 ind_genetica		    = oRegItemXML.Item(x).selectSingleNode("./IND_GENETICA").Text	
		 
		 if ind_rol_procedimentos = "S" then 
		 	imgCobertura = "check.gif"
		 else
		 	imgCobertura = "TecnicaAdm.png"
		 end if 
		 
		 if ind_diretriz = "S" then 
		 	imgDiretriz = "check.gif"
		 else
		 	imgDiretriz = "TecnicaAdm.png"
		 end if
		 
		 if ind_genetica = "S" then 
		 	imgGenetica = "check.gif"
		 else
		 	imgGenetica = "TecnicaAdm.png"
		 end if
         %>
         <tr>
            <td nowrap>
               <input type="text" id="item_medico_<%=x+1%>" name="item_medico_<%=x+1%>" size="10" maxlength="10" onKeyPress="javascript:MascAlfaNum()" OnKeyDown="TeclaEnter();" tabindex="1" onChange="CarregaGridProcedimento('<%=x+1%>','I');" value="<%=oRegItemXML.Item(x).selectSingleNode("./COD_PROCEDIMENTO_CM").Text%>" <% if ind_tipo_reembolso = 1 then %>class="camposblocks" readonly <%end if%> >
               <% if ind_forma_abertura = "IN" or ind_forma_abertura = "AL" then %>
                     <img style="cursor:hand" id="Pesquisa_Item_Medido_<%=x+1%>" name="Pesquisa_Item_Medido_<%=x+1%>" width="16" height="16" src="/gen/mid/lupa.gif" border="0" Title="Pesquisa Procedimentos/Serviços" onClick="javascript:PesquisaProcedimento('<%=x+1%>');" >
               <% end if    %>
               <input type="hidden" name="cod_procedimento_<%=x+1%>" id="cod_procedimento_<%=x+1%>"  value="<%=oRegItemXML.Item(x).selectSingleNode("./COD_PROCEDIMENTO").Text%>">
            </td>
            <td nowrap>
               <input type="text" Readonly class=camposblocks name="nome_item_proc_<%=x+1%>" size="33" value="<%=oRegItemXML.Item(x).selectSingleNode("./NOME_PROCEDIMENTO").Text%>">
               <img Title="Clique para ver o texto completo." SRC="../../GEN/IMG/folha_1.gif" onclick="mostra_detalhe_proc('<%=x+1%>')" style="cursor:hand">
               <img id='Pesquisa_deXpara_PB_<%=x+1%>' name='Pesquisa_deXpara_PB_<%=x+1%>' width='20' height='20' src='/gen/img/redirecionar_pb.png' border='0' Title='Item sem De x Para cadastrado' style='display:<%if Trim(cod_procedimento) <> "" and trim(cod_procedimento_cm) <> trim(cod_procedimento) then response.write "none" %>'>
                    <img id='Pesquisa_deXpara_<%=x+1%>' style='cursor:hand;display:<%if Trim(cod_procedimento) = "" or trim(cod_procedimento_cm) = trim(cod_procedimento) then response.write "none" %>' name='Pesquisa_deXpara_<%=x+1%>' width='20' height='20' src='/gen/img/redirecionar.png' border='0' Title='Consultar De x Para' onClick="javascript:ConsultarDePara('<%=x+1%>');">
               <%
                  qtd_glosa_analise = oRegItemXML.Item(x).selectSingleNode("./QTD_GLOSA_ANALISE").Text
                  qtd_glosa_analisada = oRegItemXML.Item(x).selectSingleNode("./QTD_GLOSA_ANALISADA").Text
                  if Cint("0" & qtd_glosa_analise) + Cint("0" & qtd_glosa_analisada) > 0 then

                    sImgErro = ""
                        if Cint("0" & qtd_glosa_analise) > 0 then
                            sImgErro = "aviso_vermelho.gif"
                        elseif Cint("0" & qtd_glosa_analisada) > 0 then
                            sImgErro = "aviso_amarelo.gif"
                        end if

                  %>
                  <img align='middle' style='display: ;cursor:hand' id="Img_Erro_<%=x+1%>" name='Img_Erro_<%=x+1%>'
                     width='20' height='20' src='/gen/img/<%=sImgErro%>' border='0'
                     Title='Visualizar Glosas da Prévia de reembolso' onClick="javascript:AbreGlosa('<%=x+1%>_1','S');">
               <%end if%>
            </td>
			
			<td align="center" nowrap>
				<img align='middle' style='cursor:hand' id='Img_Cobertura_<%=x+1%>' name='Img_Cobertura_<%=x+1%>' width='15' height='15' src='/gen/img/<%=imgCobertura%>' border='0'>				
			</td>
			
			<td align="center" nowrap>
				<img align='middle' style='cursor:hand' id='Img_Diretriz_<%=x+1%>' name='Img_Diretriz_<%=x+1%>' width='15' height='15' src='/gen/img/<%=imgDiretriz%>' border='0'>				
			</td>
			
			<td align="center" nowrap>
				<img align='middle' style='cursor:hand' id='Img_Genetica_<%=x+1%>' name='Img_Genetica_<%=x+1%>' width='15' height='15' src='/gen/img/<%=imgGenetica%>' border='0'>				
			</td>
			
			<td align="center" nowrap>
				<input type="text" id="cod_grupo_estatistico_<%=x+1%>" name="cod_grupo_estatistico_<%=x+1%>" size="3" readonly class=camposblocks value="<%=oRegItemXML.Item(x).selectSingleNode("./COD_GRUPO_ESTATISTICO").Text%>">
			</td>
			
            <td nowrap>
               <input type="checkbox" id="ind_dobra_calculo_<%=x+1%>" name="ind_dobra_calculo_<%=x+1%>" value="S" <%if oRegItemXML.Item(x).selectSingleNode("./IND_DOBRA_CALCULO").Text = "S" then %> checked <%end if%> onclick="CarregaGridProcedimento('<%=x+1%>','A');" >
            </td>
            <td nowrap>
               <input type="checkbox" id="ind_add_anestesista_<%=x+1%>" name="ind_add_anestesista_<%=x+1%>" value="S" <%if oRegItemXML.Item(x).selectSingleNode("./IND_ADD_ANESTESISTA").Text = "S" then %> checked <%end if%> <% if oRegItemXML.Item(x).selectSingleNode("./IND_ORIGEM_ANESTESISTA").Text = "P" then%> style="display:none;"<%end if%>>
               <input type="hidden" id="ind_origem_anestesista_<%=x+1%>" name="ind_origem_anestesista_<%=x+1%>" value="<%=oRegItemXML.Item(x).selectSingleNode("./IND_ORIGEM_ANESTESISTA").Text%>">
            </td>
            <td nowrap>
               <img Title="Visualizar a memória do cálculo." id="imgMemoriaCalculo_<%=x+1%>" SRC="../../GEN/IMG/folha3.gif" onclick="AbreMemoriaDeCalculo('<%=x+1%>')" style="cursor:hand" <%if qtd_funcoes > 1 then%> style="display:none" <%end if%>>
               <input type="hidden" id="txt_memoria_calculo_<%=x+1%>" name="txt_memoria_calculo_<%=x+1%>" value="<%=trataStr(oRegItemXML.Item(x).selectSingleNode("./TXT_MEMORIA_CALCULO").Text)%>">
               <input type="hidden" id="xml_memoria_calculo_<%=x+1%>" name="xml_memoria_calculo_<%=x+1%>" value="">
            </td>
            <td>
               <input type="text" id="qtd_informado_<%=x+1%>" name="qtd_informado_<%=x+1%>" size="3" maxlength="4" onKeyPress="javascript:MascInt();" tabindex="1" onchange="CarregaGridProcedimento('<%=x+1%>','A');" style="TEXT-ALIGN: right" value="<%=oRegItemXML.Item(x).selectSingleNode("./QTD_INFORMADO").Text%>" <% if ind_tipo_reembolso = 1 then %>class="camposblocks" readonly <%end if%> >
            </td>
            <td nowrap style="display: none">
               <select id="ind_situacao_<%=x+1%>" name="ind_situacao_<%=x+1%>" tabindex="1" >
                  <option value=""></option>
                  <option value='A' <%if sIndSituacao = "A" then%> selected <%end if%>>Aprovado</option>
                  <option value='N' <%if sIndSituacao = "N" then%> selected <%end if%>>Recusado</option>
                  <option value='C' <%if sIndSituacao = "C" then%> selected <%end if%>>Cancelado</option>
               </select>
            </td>
            <td>
               <select id="ind_principal_<%=x+1%>" name="ind_principal_<%=x+1%>" tabindex="1" onchange="VerificaPrincipal('<%=x+1%>');">
                  <option value="N" selected>Não</option>
                  <option value="S" <% if sIndPrincipal="S" then Response.Write " selected " %>>Sim</option>
               </select>
            </td>
            <td>
               <div id="dvVia_<%=x+1%>">
                  <select id="ind_via_<%=x+1%>" name="ind_via_<%=x+1%>" tabindex="1" onchange="VerificaPrincipal('<%=x+1%>');">
                     <option value=""></option>
                     <% if oRegItemXML.Item(x).selectSingleNode("./IND_CIRURGIA").Text = "S" AND sIndPrincipal <> "S" then %>
                        <option value='M' <% IF oRegItemXML.Item(x).selectSingleNode("./IND_VIA").Text = "M" then Response.Write " selected "%>>Mesma Via</option>
                        <option value='D' <% IF oRegItemXML.Item(x).selectSingleNode("./IND_VIA").Text = "D" then Response.Write " selected "%>>Diferentes Vias</option>
                     <%else%>
                        <option value='U' <% IF oRegItemXML.Item(x).selectSingleNode("./IND_VIA").Text = "U" then Response.Write " selected "%>>Via Única</option>
                     <% end if %>
                  </select>
               </div>
            </td>
            <td>
               <div id="dvDoppler_<%=x+1%>">
                  <select name="ind_doppler_<%=x+1%>" id="ind_doppler_<%=x+1%>" tabindex="1" onchange="VerificaPrincipal('<%=x+1%>');">
                     <option value=""></option>
                     <% if oRegItemXML.Item(x).selectSingleNode("./COD_GRUPO_ESTATISTICO").Text = "USE" then %>
                        <option value='P' <% IF oRegItemXML.Item(x).selectSingleNode("./IND_DOPPLER").Text = "P" then Response.Write " selected "%>>Pulsado e Continuo</option>
                        <option value='C' <% IF oRegItemXML.Item(x).selectSingleNode("./IND_DOPPLER").Text = "C" then Response.Write " selected "%>>Colorido</option>
                     <% end if %>
                  </select>
               </div>
            </td>

            <td nowrap>
               <input type="text" id="val_apresentado_<%=x+1%>" name="val_apresentado_<%=x+1%>" size="11" maxlength="10" onKeyPress="javascript:MascNum2()" tabindex="1" style="TEXT-ALIGN: right" value="<%=LerCampo(oRegItemXML.Item(x).selectSingleNode("./VAL_APRESENTADO").Text)%>">
            </td>

            <td nowrap><input type="text" id="val_calculado_<%=x+1%>" name="val_calculado_<%=x+1%>" size="11" maxlength="10" onKeyPress="javascript:MascNum()" tabindex="1" style="TEXT-ALIGN: right" Readonly class=camposblocks value="<%=LerCampo(oRegItemXML.Item(x).selectSingleNode("./VAL_CALCULADO").Text)%>"></td>

            <td nowrap id="tdValInformado_<%=x+1%>">
               <input type="text" id="val_reembolsado_<%=x+1%>" name="val_reembolsado_<%=x+1%>" size="11" maxlength="10" onKeyPress="javascript:MascNum()" tabindex="1" style="TEXT-ALIGN: right" value="<%=LerCampo(oRegItemXML.Item(x).selectSingleNode("./VAL_REEMBOLSADO").Text)%>" <%if qtd_funcoes > 1 then%> readonly class=camposblocks <%end if%> onchange="replicaValorInformado(<%=x+1%>)">
               <input type="hidden" name="qtd_participante_<%=x+1%>" id="qtd_participante_<%=x+1%>" value="<%=qtd_funcoes%>">
               <input type="hidden" name="ind_cirurgia_<%=x+1%>" id="ind_cirurgia_<%=x+1%>" value="<%=LerCampo(oRegItemXML.Item(x).selectSingleNode("./IND_CIRURGIA").Text)%>">
               <input type="hidden" name="grupo_beneficio_<%=x+1%>" id="grupo_beneficio_<%=x+1%>" value="<%=LerCampo(oRegItemXML.Item(x).selectSingleNode("./GRUPO_BENEFICIO").Text)%>">
               
               <input type="hidden" id="ind_acao_procedimento_<%=x+1%>" name="ind_acao_procedimento_<%=x+1%>"  value="A">
            </td>

            <td nowrap>
               <input type="text" id="val_copart_<%=x+1%>" name="val_copart_<%=x+1%>" size="11" maxlength="10" onKeyPress="javascript:MascNum()" tabindex="1" style="TEXT-ALIGN: right" Readonly class=camposblocks value="<%=LerCampo(oRegItemXML.Item(x).selectSingleNode("./VAL_COPART_TOTAL").Text)%>">
            </td>

            <td align="center" nowrap>
                <input type="checkbox" id="ind_excluir_<%=x+1%>" name="ind_excluir_<%=x+1%>" value="S"  tabindex="0">
            </td>

            <td nowrap id="td_especialidade_val_<%=x+1%>">
                <div id="dvEspecialidade_<%=x+1%>">
                    <%=MontaComboEspecialidade(x+1, oRegItemXML.Item(x).selectSingleNode("./COD_ESPECIALIDADE").Text)%>
                </div>
            </td>
			
			<input type="hidden" name="ind_rol_procedimentos_<%=x+1%>" id="ind_rol_procedimentos_<%=x+1%>" value="<%=oRegItemXML.Item(x).selectSingleNode("./IND_ROL_PROCEDIMENTOS").Text%>">
			<input type="hidden" name="ind_diretriz_<%=x+1%>"          id="ind_diretriz_<%=x+1%>" value="<%=oRegItemXML.Item(x).selectSingleNode("./IND_DIRETRIZ").Text%>">
			<input type="hidden" name="ind_genetica_<%=x+1%>"          id="ind_genetica_<%=x+1%>" value="<%=oRegItemXML.Item(x).selectSingleNode("./IND_GENETICA").Text%>">

         </tr>
         <tr id="tr_participacao_<%=x+1%>" <%if qtd_funcoes <= 1 then%> style="display:none" <%end if%>>
            <td>&nbsp;</td>
            <td colspan=9>
               <table width="100%" border="0" id="tb_dv_participante_<%=x+1%>">
                  <tr>
                     <td class="grid_cabec" width="100%">
                        <h1 class="grid_cabec"><label><font align="center" class="label_left"><b>&nbsp;Participante</b></label></h1>
                     </td>
                     <td class="label_right" >
                        <h1 class="grid_cabec"><img id="img_dv_participante_<%=x+1%>" src="../../gen/img/btn-dn.jpg" width="16" height="12" onClick="Expandir('dv_participante_<%=x+1%>');" style="cursor:hand" title="Clique para exibir Participantes" /></h1>
                     </td>
                  </tr>
               </table>
               <div id="dv_participante_<%=x+1%>" style="display:none">
                  <fieldset>
                     <table border="0" width="100%" align="center" id="tbParticipacao_<%=x+1%>">
                        <tr>
                           <td width="10%" class="grid_cabec" align=center><b>Código</td>
                           <td width="40%" class="grid_cabec" align=center><b>Nome Funcão</td>
                           <td width="10%" class="grid_cabec" align=center><b>% Part.</td>
                           <td width="20%" class="grid_cabec" align=center><b>Val. Apresentado (R$)</td>
                           <td width="20%" class="grid_cabec" align=center><b>Val. Calculado (R$)</td>
                           <td width="25%" class="grid_cabec" align=center><b>Val. Reembolsado (R$)</td>
                           <td width="10%" class="grid_cabec" align=center><b>Val. de Coparticipação (R$)</td>
                           <td width="10%" class="grid_cabec" align=center><b>Memória Cálculo</td>
                           <td width="10%" class="grid_cabec" align=center><b>Desconsiderar</td>
                        </tr>
                        <% call montaFuncoes(xml_funcoes, x+1)%>
                     </table>
                  </fieldset>
               </div>
            </td>
         </tr>
         <tr style="display: none">
            <td>
               <input type="hidden" name="num_seq_itens_proc_<%=x+1%>"  value="<%=num_seq_itens_proc%>">
            </td>
         </tr>
         <%
   Next

   Set oXMLItem = nothing
   Set oRegItemXML = nothing
    CarregaProcedimentos = x
end Function

Sub montaFuncoes(oXMLItem, pIndiceItem)
   dim disabledExcluir, i, pIndiceFuncao
   Dim oRegItemXML, x, qtd_glosa_item, sIndPrincipal, sIndSituacao
   dim sChecked, sReadOnly, sReadOnly2

   Set oRegItemXML = oXMLItem.getElementsByTagName("FUNCAO")

   pIndiceFuncao = 1
   For x = 0 To oRegItemXML.Length - 1
      'if oRegItemXML.Item(x).selectSingleNode("./COD_PROCEDIMENTO_CM").Text = pCodProcedimentoCm then
         'disabledExcluir = ""

         'if oRegItemXML.Item(x).selectSingleNode("./IND_FUNCAO").Text = "00" or oRegItemXML.Item(x).selectSingleNode("./IND_FUNCAO").Text = "12" then
         '   disabledExcluir = "style='display=none'"
         'end if

         sChecked = ""
         sReadOnly = ""
         if oRegItemXML.Item(x).selectSingleNode("./IND_SITUACAO_FUNCAO").Text <> "A" then
            sChecked = "checked"
            sReadOnly = "readonly class=camposblocks"
         end if
         sReadOnly2 = "readonly class=camposblocks"

         %>
         <tr>
            <td class="grid_center">
               <center><label id="lbl_cod_funcao_<%=pIndiceItem%>_<%=pIndiceFuncao%>"><%=oRegItemXML.Item(x).selectSingleNode("./IND_FUNCAO").Text%></label></center>
               <input type="hidden" id="ind_funcao_<%=pIndiceItem%>_<%=pIndiceFuncao%>" name="ind_funcao_<%=pIndiceItem%>_<%=pIndiceFuncao%>" value="<%=oRegItemXML.Item(x).selectSingleNode("./IND_FUNCAO").Text%>">
            </td>

            <td class="grid_left">
               <label id="lbl_nome_funcao_<%=pIndiceItem%>_<%=pIndiceFuncao%>"><%=oRegItemXML.Item(x).selectSingleNode("./NOME_FUNCAO").Text%></label>
               <input type="hidden" id="nome_funcao_<%=pIndiceItem%>_<%=pIndiceFuncao%>" name="nome_funcao_<%=pIndiceItem%>_<%=pIndiceFuncao%>" value="<%=oRegItemXML.Item(x).selectSingleNode("./NOME_FUNCAO").Text%>">
               <%
                  qtd_glosa_analise = oRegItemXML.Item(x).selectSingleNode("./QTD_GLOSA_ANALISE").Text
                  qtd_glosa_analisada = oRegItemXML.Item(x).selectSingleNode("./QTD_GLOSA_ANALISADA").Text
                  if Cint("0" & qtd_glosa_analise) + Cint("0" & qtd_glosa_analisada) > 0 then

                    sImgErro = ""
                        if Cint("0" & qtd_glosa_analise) > 0 then
                            sImgErro = "aviso_vermelho.gif"
                        elseif Cint("0" & qtd_glosa_analisada) > 0 then
                            sImgErro = "aviso_amarelo.gif"
                        end if

                  %>
                  <img align='middle' style='display: ;cursor:hand' id="Img_Erro_<%=pIndiceItem%>_<%=pIndiceFuncao%>" name='Img_Erro_<%=pIndiceItem%>_<%=pIndiceFuncao%>'
                     width='20' height='20' src='/gen/img/<%=sImgErro%>' border='0'
                     Title='Visualizar Glosas da Prévia de reembolso' onClick="javascript:AbreGlosa('<%=pIndiceItem%>_<%=pIndiceFuncao%>','S');">
               <%end if%>

               <input type="hidden" name="txt_xml_pedido_item_<%=pIndiceItem%>_<%=pIndiceFuncao%>" id="txt_xml_pedido_item_<%=pIndiceItem%>_<%=pIndiceFuncao%>" value="">
            </td>

            <td class="grid_right">
               <label id="lbl_pct_participacao_<%=pIndiceItem%>_<%=pIndiceFuncao%>"><%=oRegItemXML.Item(x).selectSingleNode("./PERC_FUNCAO_LABEL").Text%></label>
               <input type="hidden" name="pct_participacao_<%=pIndiceItem%>_<%=pIndiceFuncao%>" value="<%=oRegItemXML.Item(x).selectSingleNode("./PERC_FUNCAO").Text%>">
            </td>

            <td class="grid_right">
               <input type="text" name="val_apresentado_<%=pIndiceItem%>_<%=pIndiceFuncao%>" value="<%=oRegItemXML.Item(x).selectSingleNode("./VAL_APRESENTADO").Text%>" size="14" maxlength="10" onKeyPress="javascript:MascNum2()" tabindex="1" onchange="SomaParticipacao('<%=pIndiceItem%>')" style="TEXT-ALIGN: right" <%=sReadOnly%>>
            </td>

            <td class="grid_right">
               <label id="lbl_val_calculado_<%=pIndiceItem%>_<%=pIndiceFuncao%>"><%=oRegItemXML.Item(x).selectSingleNode("./VAL_CALCULADO").Text%></label>
               <input type="hidden" id="val_calculado_<%=pIndiceItem%>_<%=pIndiceFuncao%>" name="val_calculado_<%=pIndiceItem%>_<%=pIndiceFuncao%>" value="<%=oRegItemXML.Item(x).selectSingleNode("./VAL_CALCULADO").Text%>">
               <input type="hidden" id="val_calculado_orig_<%=pIndiceItem%>_<%=pIndiceFuncao%>" name="val_calculado_orig_<%=pIndiceItem%>_<%=pIndiceFuncao%>" value="<%=oRegItemXML.Item(x).selectSingleNode("./VAL_CALCULADO").Text%>">
            </td>

            <td class="grid_right">
               <input type="text" name="val_informado_<%=pIndiceItem%>_<%=pIndiceFuncao%>" value="<%=oRegItemXML.Item(x).selectSingleNode("./VAL_REEMBOLSADO").Text%>" size="14" maxlength="10" onKeyPress="javascript:MascNum()" tabindex="1" onchange="SomaParticipacao('<%=pIndiceItem%>')"style="TEXT-ALIGN: right" <%=sReadOnly%>>
            </td>

            <td class="grid_right">
               <input type="text" name="val_copart_<%=pIndiceItem%>_<%=pIndiceFuncao%>" value="<%=oRegItemXML.Item(x).selectSingleNode("./VAL_COPART").Text%>" size="14" maxlength="10" onKeyPress="javascript:MascNum()" tabindex="1" style="TEXT-ALIGN: right" <%=sReadOnly2%>>
            </td>

            <td class="grid_center">
               <img Title="Visualizar a memória do cálculo." SRC="../../GEN/IMG/folha3.gif" onclick="AbreMemoriaDeCalculo('<%=pIndiceItem%>_<%=pIndiceFuncao%>')" style="cursor:hand" >
               <input type="hidden" id="txt_memoria_calculo_<%=pIndiceItem%>_<%=pIndiceFuncao%>" name="txt_memoria_calculo_<%=pIndiceItem%>_<%=pIndiceFuncao%>" value="<%=trataStr(oRegItemXML.Item(x).selectSingleNode("./TXT_MEMORIA_CALCULO").Text)%>">
               <input type="hidden" id="xml_memoria_calculo_<%=pIndiceItem%>_<%=pIndiceFuncao%>" name="xml_memoria_calculo_<%=pIndiceItem%>_<%=pIndiceFuncao%>" value="">
            </td>

            <td class="grid_center">
               <center><input type="checkbox" name="ind_excluir_<%=pIndiceItem%>_<%=pIndiceFuncao%>" value="S" tabindex="1" onclick="HabDesabLinhaParticipacao('<%=pIndiceItem%>','<%=pIndiceFuncao%>');" <%=sChecked%> ></center>
               
               <input type="hidden" name="ind_tipo_composicao_<%=pIndiceItem%>_<%=pIndiceFuncao%>" id="ind_tipo_composicao_<%=pIndiceItem%>_<%=pIndiceFuncao%>" value="<%=oRegItemXML.Item(x).selectSingleNode("./IND_TIPO_COMPOSICAO").Text%>">
               <input type="hidden" name="val_cotacao_rb_<%=pIndiceItem%>_<%=pIndiceFuncao%>" id="val_cotacao_rb_<%=pIndiceItem%>_<%=pIndiceFuncao%>" value="<%=oRegItemXML.Item(x).selectSingleNode("./VAL_COTACAO_RB").Text%>">
               <input type="hidden" name="sigla_tabela_rb_<%=pIndiceItem%>_<%=pIndiceFuncao%>" id="sigla_tabela_rb_<%=pIndiceItem%>_<%=pIndiceFuncao%>" value="<%=oRegItemXML.Item(x).selectSingleNode("./SIGLA_TABELA_RB").Text%>">
               <input type="hidden" name="cod_porte_rb_<%=pIndiceItem%>_<%=pIndiceFuncao%>" id="cod_porte_rb_<%=pIndiceItem%>_<%=pIndiceFuncao%>" value="<%=oRegItemXML.Item(x).selectSingleNode("./COD_PORTE_RB").Text%>">
               <input type="hidden" name="sigla_tabela_taxas_<%=pIndiceItem%>_<%=pIndiceFuncao%>" id="sigla_tabela_taxas_<%=pIndiceItem%>_<%=pIndiceFuncao%>" value="<%=oRegItemXML.Item(x).selectSingleNode("./SIGLA_TABELA_TAXAS").Text%>">
               <input type="hidden" name="val_cotacao_taxa_<%=pIndiceItem%>_<%=pIndiceFuncao%>" id="val_cotacao_taxa_<%=pIndiceItem%>_<%=pIndiceFuncao%>" value="<%=oRegItemXML.Item(x).selectSingleNode("./VAL_COTACAO_TAXA").Text%>">
               <input type="hidden" name="pct_cirurgia_multipla_<%=pIndiceItem%>_<%=pIndiceFuncao%>" id="pct_cirurgia_multipla_<%=pIndiceItem%>_<%=pIndiceFuncao%>" value="<%=oRegItemXML.Item(x).selectSingleNode("./PCT_CIRURGIA_MULTIPLA").Text%>">
               <input type="hidden" name="qtd_vezes_tabela_<%=pIndiceItem%>_<%=pIndiceFuncao%>" id="qtd_vezes_tabela_<%=pIndiceItem%>_<%=pIndiceFuncao%>" value="<%=oRegItemXML.Item(x).selectSingleNode("./QTD_VEZES_TABELA").Text%>">
               <input type="hidden" name="qtd_prazo_dias_<%=pIndiceItem%>_<%=pIndiceFuncao%>" id="qtd_prazo_dias_<%=pIndiceItem%>_<%=pIndiceFuncao%>" value="<%=oRegItemXML.Item(x).selectSingleNode("./QTD_PRAZO_DIAS").Text%>">
               <input type="hidden" name="sigla_moeda_<%=pIndiceItem%>_<%=pIndiceFuncao%>" id="sigla_moeda_<%=pIndiceItem%>_<%=pIndiceFuncao%>" value="<%=oRegItemXML.Item(x).selectSingleNode("./SIGLA_MOEDA").Text%>">
               <input type="hidden" name="val_limite_<%=pIndiceItem%>_<%=pIndiceFuncao%>" id="val_limite_<%=pIndiceItem%>_<%=pIndiceFuncao%>" value="<%=oRegItemXML.Item(x).selectSingleNode("./VAL_LIMITE").Text%>">
               <input type="hidden" name="val_fixo_<%=pIndiceItem%>_<%=pIndiceFuncao%>" id="val_fixo_<%=pIndiceItem%>_<%=pIndiceFuncao%>" value="<%=oRegItemXML.Item(x).selectSingleNode("./VAL_FIXO").Text%>">
               <input type="hidden" name="cod_concessao_<%=pIndiceItem%>_<%=pIndiceFuncao%>" id="cod_concessao_<%=pIndiceItem%>_<%=pIndiceFuncao%>" value="<%=oRegItemXML.Item(x).selectSingleNode("./COD_CONCESSAO").Text%>">
               <input type="hidden" name="cod_reembolso_<%=pIndiceItem%>_<%=pIndiceFuncao%>" id="cod_reembolso_<%=pIndiceItem%>_<%=pIndiceFuncao%>" value="<%=oRegItemXML.Item(x).selectSingleNode("./COD_REEMBOLSO").Text%>">
               <input type="hidden" name="pct_recibo_<%=pIndiceItem%>_<%=pIndiceFuncao%>" id="pct_recibo_<%=pIndiceItem%>_<%=pIndiceFuncao%>" value="<%=oRegItemXML.Item(x).selectSingleNode("./PCT_RECIBO").Text%>">
               <input type="hidden" name="num_seq_item_<%=pIndiceItem%>_<%=pIndiceFuncao%>"  value="<%=oRegItemXML.Item(x).selectSingleNode("./NUM_SEQ_ITEM").Text%>">
            </td>
         </tr>
         <%
         pIndiceFuncao = pIndiceFuncao + 1
         if num_seq_itens_proc <> "" then
            num_seq_itens_proc = num_seq_itens_proc & "," & oRegItemXML.Item(x).selectSingleNode("./NUM_SEQ_ITEM").Text
         else
            num_seq_itens_proc = oRegItemXML.Item(x).selectSingleNode("./NUM_SEQ_ITEM").Text
         end if
      'end if
   next

end Sub
'-----------------------------------------------------------------------
'Retornar se arquivo informado é uma imagem prevista
'--------------------------------------------------------45---------------
function ImagemExtensaoArquivo (pNomeArquivo)
    Dim sExtensao
    if Isnull(pNomeArquivo) then
        ImagemExtensaoArquivo  = false
    else
        if instr(pNomeArquivo,".") = 0 then
            ImagemExtensaoArquivo  = false
        else
            sExtensao = mid(pNomeArquivo,instr(pNomeArquivo,".")+1)
            if    ucase(sExtensao) = "GIF" _
               or ucase(sExtensao) = "JPG" _
               or ucase(sExtensao) = "BMP" _
               or ucase(sExtensao) = "TIF" _
               or ucase(sExtensao) = "JPEG" _
               or ucase(sExtensao) = "PNG" _
            then
                ImagemExtensaoArquivo  = true
            else
                ImagemExtensaoArquivo  = false
            end if
        end if
    end if

end function

function trataStr(str)
 dim strTratado
   strTratado = replace(str,"""","&quot;")
   strTratado = replace(strTratado,"'","&#39;")

trataStr = strTratado
end function

'-----------------------------------------------------------------------
' Retorna se o usuario logado possui permissão para a função informada
'-----------------------------------------------------------------------
function PermissaoFuncao(pCodFuncao)
    Dim oXML, oFuncaoXML, x

    PermissaoFuncao = false

   if trim(xml_permissoes) = "" then exit function

    Set oXML = CreateObject("Microsoft.XMLDOM")
    oXML.async = False
    oXML.loadXML(xml_permissoes)
    Set oFuncaoXML  = oXML.getElementsByTagName("USUARIO_FUNCAO/DADOS")

    For x = 0 To oFuncaoXML.Length - 1
      if UCASE(LerXMLLoop(x, "COD_FUNCAO", oFuncaoXML)) = UCASE(pCodFuncao) then
            PermissaoFuncao = true
            exit for
        end if
    next

    Set oFuncaoXML = Nothing
    Set oXML = Nothing
end function
'-----------------------------------------------------------------------
'Retornar um XML com as funções que o usuário tem acesso
'-----------------------------------------------------------------------
function RetornarXMLFuncao()

    Dim vetFuncao(5, 4)

    vetFuncao(1, 1) = "OUT"
    vetFuncao(1, 2) = "adLongVarChar"
    vetFuncao(1, 3) = "p_xml_retorno"

    vetFuncao(2, 1) = "OUT"
    vetFuncao(2, 2) = "adDouble"
    vetFuncao(2, 3) = "p_cod_retorno"

    vetFuncao(3, 1) = "OUT"
    vetFuncao(3, 2) = "adVarChar"
    vetFuncao(3, 3) = "p_msg_retorno"

    vetFuncao(4, 1) = "IN"
    vetFuncao(4, 2) = "adVarChar"
    vetFuncao(4, 3) = "p_cod_usuario"
    vetFuncao(4, 4) = session("ace_usuario")

    vetFuncao(5, 1) = "IN"
    vetFuncao(5, 2) = "adVarChar"
    vetFuncao(5, 3) = "p_cod_usuario"
    vetFuncao(5, 4) = session("ace_tipo_usuario")

    Call ExecutaPLOracle(   CStr(session("ace_usuario")),_
                        CStr(session("ace_senha")),_
                        CStr(session("ace_ip")),_
                        CStr(session("ace_sistema")),_
                        CStr(session("ace_modulo")),_
                        "RB_PREVIA_REEMBOLSO.get_xml_permissoes", _
                        vetFuncao, _
                        false )

   if vetFuncao(2, 4) = "0" then
        RetornarXMLFuncao = vetFuncao(1, 4)
    else
        Response.Write "<BR>Erro ao recuperar as funções do usuário:<BR>" & vetFuncao(3, 4)
    end if

end function

'-----------------------------------------------------------------------
' Lê o nó informado dentro objeto / indice informado
'-----------------------------------------------------------------------
function LerXMLLoop(pIndice, pNomeNo, pObjeto)
    on error resume next
    LerXMLLoop = pObjeto.Item(pIndice).selectSingleNode("./" & pNomeNo).Text
    if err.number <> 0 then
        LerXMLLoop = ""
    end if
    on error goto 0
end function

%>

<SCRIPT LANGUAGE="javascript">
if(document.form01.ind_retorno_relatorio.value == 'S'){
   document.form01.ind_retorno_relatorio.value = '';
   parent.parent.frames['principal'].window.location = '../../rbm/asp/rbm0078a.asp?PT=<%=txt_subtitulo%>&ind_forma_abertura=<%=ind_forma_abertura%>&txt_msg=<%=txt_msg%>&ind_retorno_relatorio=N';

}

   try {
      document.form01.num_associado.focus();
   } catch(e){
    };
   //-->
   //Barata inicio
   if (form01.exibe_alerta_cadastral.value == 'S')
       AbrePesquisaCrossBrowser('../../atb/asp/atb0103d.asp?pt=Confirmação Cadastral' + form01.strauxurl.value, 'Confirmação Cadastral', 'Confirmação Cadastral', 900, 600, 20, 15, 'S');
   //Barata fim

   var janela;

function retornaQtdFamilia(){

	var pCodTs;

	pCodTs = document.form01.cod_ts.value;

	var cp = new cpaint();
	cp.set_transfer_mode('get');
	cp.set_response_type('text');
	cp.set_debug(false);
	cp.call('../../rbm/asp/rbm0079f.asp', 'RetornaQtdFamilia', ExibeIconeFamilia, pCodTs ); 
}
//------------------------------------------------------------------
function ExibeIconeFamilia(pQtdFamilia) {

	if (  pQtdFamilia > 1 ){
		document.getElementById("Pesquisa_Familia").style.display = "";
	}else{
		document.getElementById("Pesquisa_Familia").style.display = "none";		
	}	

}

//------------------------------------------------------------------------------------
function AbrePesquisaFamilia(){
	var vParam;
	vParam  = '&cod_ts=' + form01.cod_ts.value;
	vParam += '&num_associado=' + form01.num_associado.value;
	vParam += '&nome_associado=' + form01.nome_associado.value;
	vParam += '&ind_origem_associado=' + form01.ind_origem_associado.value;	

	//vParam += '&nome_associado=' + form01.nome_associado.value;
	AbrePesquisaCrossBrowser('/rbm/asp/rbm1003o.asp?pt=Família Beneficiário'+vParam,'Pesquisa_Familia','Pesquisa Família Beneficiário', 800, 400, 20, 15,'S');
}
//------------------------------------------------------------------------------------
function verMesgIni(){
    <%if(aux_tem_msg = "S" and (ind_forma_abertura = "AL" or ind_forma_abertura = "DP")) then%>
       exibeMensagemAtd(4);
    <%end if%>
}
//------------------------------------------------------------------------------
function ConsultarDePara(pIndice) {
    if (document.getElementById('item_medico_' + pIndice).value=="")
        return false;

    var cp = new cpaint();
    cp.set_transfer_mode('get');
    cp.set_debug(false);
    cp.set_response_type('text');
    cp.call('../../atd/asp/atd0027m.asp', 'retornaDadosDePara', exibeDadosDePara, document.getElementById('item_medico_' + pIndice).value, form01.dt_solicitacao.value);
}

//------------------------------------------------------------------------------
function exibeDadosDePara(pXML) {

    var xmlDoc;
    var sChamada    = '';

    if (window.ActiveXObject) {
        xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
        xmlDoc.async    = false;
        xmlDoc.loadXML(pXML);
    }
    else {
        parser = new DOMParser();
        xmlDoc = parser.parseFromString(pXML, "text/xml");
    }

    var xml_no = xmlDoc.getElementsByTagName("DADOS");
    for (var x=0; x < xml_no.length; x++) {
        if (xml_no[x].getElementsByTagName("COD_PADRAO")[0].childNodes[0].nodeValue == 'AMB')
            sChamada  = '../../HES/ASP/HES0013A.asp?PT=AMB X CBHPM (TUSS)&ind_autorizacao=S';
        else
            sChamada  = '../../HES/ASP/HES0014A.asp?PT=CBHPM (TUSS) X AMB&ind_autorizacao=S';
        sChamada += '&cod_tipo_depara=' + xml_no[x].getElementsByTagName("COD_TIPO_DEPARA")[0].childNodes[0].nodeValue;
        sChamada += '&dt_vigencia='     + xml_no[x].getElementsByTagName("DT_VIGENCIA")[0].childNodes[0].nodeValue;
        sChamada += '&item_medico='     + xml_no[x].getElementsByTagName("ITEM_MEDICO")[0].childNodes[0].nodeValue;
        break;
    }

    AbrePesquisa(sChamada, 'Dados_DePara', 'De Para', 850, 600, 20, 15, 'S');
}
//------------------------------------------------------------------------
function AbrePesquisaAutorizacao() {
    var sChamada = '/rbm/asp/rbm1003j.asp';
    sChamada    += '?num_associado='     + form01.num_associado.value;
    sChamada    += '&nome_campo_cod=num_internacao';
    sChamada    += '&funcao_executar=exibeHistAutorizacao()';

    AbrePesquisaCrossBrowser(sChamada,'Pesquisa_Autorizacao','Pesquisa Autorização', 900, 500, 5, 5, 'S');
}

function exibeHistAutorizacao(){
   if ( document.form01.num_internacao.value != '' ){
      document.getElementById("historico_aut").style.display='';
   }else{
      document.getElementById("historico_aut").style.display='none';
   }
}

//CARREGA DADOS AUTORIZAÇÃO
//------------------------------------------------------------------
function CarregaAutorizacao() {

   var cp = new cpaint();
   cp.set_transfer_mode('get');
   cp.set_response_type('text');
   cp.set_debug(false);
   cp.call('../../rbm/asp/rbm0079f.asp', 'CarregaAutorizacao', ExibeAutorizacao, form01.num_internacao.value, form01.num_associado.value);
}
//------------------------------------------------------------------
function ExibeAutorizacao(pDescricao) {
   document.getElementById('txt_msg').innerHTML="";
   document.getElementById('txt_msg').style.display='none';

   if (pDescricao=="-1")    {
      document.getElementById('txt_msg').innerHTML="Pedido de autorização não encontrado para este Beneficiário!";
      document.getElementById('txt_msg').style.display='';
        document.getElementById('historico_aut').style.display='none';
      form01.num_internacao.value="";
   }else{
      form01.num_internacao.value=pDescricao;
      document.getElementById('historico_aut').style.display='';
   }
}
//Carregar dados do Beneficiário ------------------------------------------------------------------------
function CarregaDadosAssociado() {


   var sValue;



   document.getElementById('txt_msg').innerHTML     = 'Aguarde. Carregando dados do beneficiário.';
   document.getElementById('txt_msg').style.display = '';

   document.form01.num_associado.disabled = true;

   form01.nome_associado.style.display = '';
   ValidaPerfilPrevencaoFraude();

   if (form01.num_associado.value == "") {
      document.getElementById('txt_msg').innerHTML     = '';
      document.getElementById('txt_msg').style.display = 'none';
      LimpaDadosAssociado();
      document.form01.num_associado.disabled = false;
      return false;
   }

   sValue = form01.num_associado.value;
   sValue = sValue.toString().replace( /\./g, "" );
   form01.num_associado.value     = sValue;

   var cp_ass = new cpaint();
   cp_ass.set_transfer_mode('get');
   cp_ass.set_debug(false);
   cp_ass.set_response_type('text');
   cp_ass.set_async(false);

   cp_ass.call('../../rbm/asp/rbm0079f.asp', 'CarregaDadosAssociado', ExibeDadosAssociado, form01.num_associado.value, form01.dt_solicitacao.value);


   if (form01.aux_tem_msg.value == 'S') {
       exibeMensagemAtd(4);
   }

}

function ValidaPerfilPrevencaoFraude() {

    var cp_ass = new cpaint();
    cp_ass.set_transfer_mode('get');
    cp_ass.set_debug(false);
    cp_ass.set_response_type('text');

    cp_ass.call('../../rbm/asp/rbm0079f.asp', 'ValidaPerfilPrevencaoFraude', retornoValidaPrevencaoFraude, "<%=txt_usuario%>");

}

function retornoValidaPrevencaoFraude(retorno)
{
    form01.valida_perfil_fraude.value = retorno;
    if ( retorno == "0") {
        document.getElementById('Pesquisa_Acao_Judicial_cliente').style.display = 'none';
    }
}

function ExibeDadosAssociado(pXML)
{
   var xmlDoc            = null;
   var xml_no            = null;
   var validaPerfil;

    validaPerfil = form01.valida_perfil_fraude.value;

   document.getElementById('txt_msg').innerHTML     = '';
   document.getElementById('txt_msg').style.display = 'none';

   form01.num_associado.disabled = false;

   //ABRIR O XML
   //try{
   if (window.ActiveXObject) {
       xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
       xmlDoc.async = false;
       xmlDoc.loadXML(pXML);
   }
   else {
       parser = new DOMParser();
       xmlDoc = parser.parseFromString(pXML, "text/xml");
   }

      xml_no = xmlDoc.getElementsByTagName("ROW");

      LimpaDadosAssociado();

      for(var x=0; x < xml_no.length; x++)
      {
         if (xml_no[x].getElementsByTagName("COD_RETORNO")[0].childNodes[0].nodeValue == "9") //NAO ACHOU O BENEFICIARIO
         {
             document.getElementById('txt_msg').innerHTML = xml_no[x].getElementsByTagName("MSG_RETORNO")[0].childNodes[0].nodeValue;
            document.getElementById('txt_msg').style.display = '';
            form01.num_associado.value = "";
            form01.nome_associado.value   = "";
            form01.num_associado.focus();
            return false;

         }else{ //ACHOU O BENEFICIARIO

             data_atual = xml_no[x].getElementsByTagName("DATA_ATUAL")[0].childNodes[0].nodeValue;

             if (xml_no[x].getElementsByTagName("DATA_EXCLUSAO")[0].childNodes.length > 0) {
                 if (xml_no[x].getElementsByTagName("IND_SITUACAO")[0].childNodes[0].nodeValue=="E" || ComparaData(xml_no[x].getElementsByTagName("DATA_EXCLUSAO")[0].childNodes[0].nodeValue, data_atual, 'DD/MM/YYYY', '<') ){

                     document.getElementById('txt_msg').innerHTML = "O beneficiário digitado esta excluído e não pode ser criada prévia de reembolso para o mesmo."
                     document.getElementById('txt_msg').style.display = '';
                     form01.num_associado.value = "";
                     form01.nome_associado.value   = "";
                     form01.num_associado.focus();

                     return false;
                 }
             }

             form01.cod_ts.value               = xml_no[x].getElementsByTagName("COD_TS")[0].childNodes[0].nodeValue;
             form01.num_associado.value         = xml_no[x].getElementsByTagName("NUM_ASSOCIADO")[0].childNodes[0].nodeValue;
             form01.cod_ts_contrato.value      = xml_no[x].getElementsByTagName("COD_TS_CONTRATO")[0].childNodes[0].nodeValue;
             form01.dt_ini_vigencia.value      = xml_no[x].getElementsByTagName("DT_INI_VIGENCIA")[0].childNodes[0].nodeValue;
             form01.nome_associado.value         = xml_no[x].getElementsByTagName("NOME_ASSOCIADO")[0].childNodes[0].nodeValue;
             form01.num_contrato.value         = xml_no[x].getElementsByTagName("NUM_CONTRATO")[0].childNodes[0].nodeValue;
             form01.cod_grupo_empresa.value        = xml_no[x].getElementsByTagName("COD_GRUPO_EMPRESA")[0].childNodes[0].nodeValue;

             if (form01.cod_grupo_empresa.value == 0) {
                form01.cod_grupo_empresa.value = "";
             }

            if (form01.num_contrato.value!="")
                form01.nome_contrato_exibicao.value      = form01.num_contrato.value + " - " + xml_no[x].getElementsByTagName("NOME_CONTRATO")[0].childNodes[0].nodeValue;
            form01.nome_contrato.value      = xml_no[x].getElementsByTagName("NOME_CONTRATO")[0].childNodes[0].nodeValue;
            form01.data_nascimento.value      = xml_no[x].getElementsByTagName("DATA_NASCIMENTO")[0].childNodes[0].nodeValue;
            if (form01.data_nascimento.value!=""){
                form01.idade_associado.value            = xml_no[x].getElementsByTagName("IDADE_ASSOCIADO")[0].childNodes[0].nodeValue;
                form01.idade_associado_exibicao.value    = xml_no[x].getElementsByTagName("IDADE_ASSOCIADO")[0].childNodes[0].nodeValue + " anos";
            }
            form01.cod_plano.value            = xml_no[x].getElementsByTagName("COD_PLANO")[0].childNodes[0].nodeValue;
            form01.nome_plano.value            = form01.cod_plano.value + " - " + xml_no[x].getElementsByTagName("NOME_PLANO")[0].childNodes[0].nodeValue;
            form01.cod_rede.value              = xml_no[x].getElementsByTagName("COD_REDE")[0].childNodes[0].nodeValue;
            if (xml_no[x].getElementsByTagName("COD_REDE")[0].childNodes[0].nodeValue != "")
                form01.nom_rede.value          = xml_no[x].getElementsByTagName("COD_REDE")[0].childNodes[0].nodeValue + " - " + xml_no[x].getElementsByTagName("NOM_REDE")[0].childNodes[0].nodeValue;
            else
                form01.nom_rede.value          = xml_no[x].getElementsByTagName("NOM_REDE")[0].childNodes[0].nodeValue;
            form01.data_inclusao.value          = xml_no[x].getElementsByTagName("DATA_INCLUSAO")[0].childNodes[0].nodeValue;

            if (xml_no[x].getElementsByTagName("DATA_EXCLUSAO")[0].childNodes.length > 0) {
                form01.data_exclusao.value          = xml_no[x].getElementsByTagName("DATA_EXCLUSAO")[0].childNodes[0].nodeValue;
            }

            form01.ind_situacao.value           = xml_no[x].getElementsByTagName("IND_SITUACAO")[0].childNodes[0].nodeValue;
            form01.nom_situacao_associado.value = xml_no[x].getElementsByTagName("NOM_SITUACAO_ASSOCIADO")[0].childNodes[0].nodeValue;
            form01.nome_operadora.value        = xml_no[x].getElementsByTagName("NOM_OPERADORA")[0].childNodes[0].nodeValue;
            form01.cod_operadora.value         = xml_no[x].getElementsByTagName("COD_OPERADORA")[0].childNodes[0].nodeValue;
            form01.cod_marca.value         = xml_no[x].getElementsByTagName("COD_MARCA")[0].childNodes[0].nodeValue;

            var xml_no_contato = xml_no[x].getElementsByTagName("CONTATO")[0];

            if (xml_no_contato.getElementsByTagName("NUM_DDD_FAX")[0].childNodes.length > 0) {
                form01.txt_ddd_fax.value         = xml_no_contato.getElementsByTagName("NUM_DDD_FAX")[0].childNodes[0].nodeValue;
            }

            if (xml_no_contato.getElementsByTagName("NUM_FAX")[0].childNodes.length > 0) {
                form01.txt_num_fax.value         = xml_no_contato.getElementsByTagName("NUM_FAX")[0].childNodes[0].nodeValue;
            }

            if (xml_no_contato.getElementsByTagName("END_EMAIL")[0].childNodes.length > 0) {
                form01.txt_email.value           = xml_no_contato.getElementsByTagName("END_EMAIL")[0].childNodes[0].nodeValue;
            }

            if (xml_no_contato.getElementsByTagName("NUM_DDD_TELEFONE")[0].childNodes.length > 0) {
                form01.ddd_residencial.value     = xml_no_contato.getElementsByTagName("NUM_DDD_TELEFONE")[0].childNodes[0].nodeValue;
            }

            if (xml_no_contato.getElementsByTagName("NUM_TELEFONE")[0].childNodes.length > 0) {
                form01.tel_residencial.value     = xml_no_contato.getElementsByTagName("NUM_TELEFONE")[0].childNodes[0].nodeValue;
            }

            if (xml_no_contato.getElementsByTagName("NUM_DDD_CELULAR")[0].childNodes.length > 0) {
                form01.ddd_celular.value         = xml_no_contato.getElementsByTagName("NUM_DDD_CELULAR")[0].childNodes[0].nodeValue;
            }

            if (xml_no_contato.getElementsByTagName("NUM_CELULAR")[0].childNodes.length > 0) {
                form01.tel_celular.value         = xml_no_contato.getElementsByTagName("NUM_CELULAR")[0].childNodes[0].nodeValue;
            }

            if (xml_no_contato.getElementsByTagName("NUM_DDD_CELULAR")[0].childNodes.length > 0) {
                form01.ddd_comercial.value       = xml_no_contato.getElementsByTagName("NUM_DDD_CELULAR")[0].childNodes[0].nodeValue;
            }

            if (xml_no_contato.getElementsByTagName("NUM_CELULAR")[0].childNodes.length > 0) {
                form01.tel_comercial.value       = xml_no_contato.getElementsByTagName("NUM_CELULAR")[0].childNodes[0].nodeValue;
            }

            form01.ind_plano_com_reembolso.value   = xml_no[x].getElementsByTagName("IND_PLANO_COM_REEMBOLSO")[0].childNodes[0].nodeValue;
            form01.ind_regulamentado.value         = xml_no[x].getElementsByTagName("IND_REGULAMENTADO")[0].childNodes[0].nodeValue;
            form01.num_titular.value               = xml_no[x].getElementsByTagName("NUM_ASSOCIADO_TIT")[0].childNodes[0].nodeValue;
            form01.nome_titular.value              = xml_no[x].getElementsByTagName("NOME_ASSOCIADO_TIT")[0].childNodes[0].nodeValue;

            form01.tipo_associado.value            = xml_no[x].getElementsByTagName("TIPO_ASSOCIADO")[0].childNodes[0].nodeValue;
            form01.cod_ts_tit.value                = xml_no[x].getElementsByTagName("COD_TS_TIT")[0].childNodes[0].nodeValue;
            form01.cod_entidade_ts_tit.value       = xml_no[x].getElementsByTagName("COD_ENTIDADE_TS_TIT")[0].childNodes[0].nodeValue;

            form01.nome_filial.value               = xml_no[x].getElementsByTagName("NOME_SUCURSAL")[0].childNodes[0].nodeValue;
            if (xml_no[x].getElementsByTagName("NOME_INSPETORIA")[0].childNodes[0].nodeValue != "")
                form01.nome_filial.value       =  form01.nome_filial.value + " / " + xml_no[x].getElementsByTagName("NOME_INSPETORIA")[0].childNodes[0].nodeValue;
            form01.cod_inspetoria_ts.value     = xml_no[x].getElementsByTagName("COD_INSPETORIA_TS")[0].childNodes[0].nodeValue;
            <%if (ind_acesso_cam = "S" or txt_modulo = 40) and ind_consulta = "S" then%>
               form01.cod_inspetoria_ts_abertura.value     = xml_no[x].getElementsByTagName("COD_INSPETORIA_TS")[0].childNodes[0].nodeValue;
            <%end if%>
            //form01.qtd_dias_reembolso.value     = xml_no[x].getElementsByTagName("QTD_DIAS_REEMBOLSO")[0].text;

            form01.ind_sexo.value                = xml_no[x].getElementsByTagName("IND_SEXO")[0].childNodes[0].nodeValue;
            form01.ind_origem_associado.value      = xml_no[x].getElementsByTagName("IND_ORIGEM_ASSOCIADO")[0].childNodes[0].nodeValue;
            form01.tipo_pessoa_contrato.value      = xml_no[x].getElementsByTagName("TIPO_PESSOA_CONTRATO")[0].childNodes[0].nodeValue;

            if (xml_no[x].getElementsByTagName("IND_ERRO_WS")[0].childNodes.length > 0) {
                form01.ind_erro_ws.value             = xml_no[x].getElementsByTagName("IND_ERRO_WS")[0].childNodes[0].nodeValue;
            }
            if (xml_no[x].getElementsByTagName("MSG_ERRO_WS")[0].childNodes.length > 0) {
                form01.msg_erro_ws.value             = xml_no[x].getElementsByTagName("MSG_ERRO_WS")[0].childNodes[0].nodeValue;
            }
			
				form01.data_adaptacao.value		    = xml_no[x].getElementsByTagName("DATA_ADAPTACAO")[0].text;
				form01.tem_aditivo.value		    = xml_no[x].getElementsByTagName("TEM_ADITIVO")[0].text;
			
            if (xml_no[x].getElementsByTagName("IND_SEXO")[0].childNodes[0].nodeValue == "M")
               form01.txt_sexo.value               = 'Masculino';
            else if (xml_no[x].getElementsByTagName("IND_SEXO")[0].childNodes[0].nodeValue == "F")
               form01.txt_sexo.value               = 'Feminino';

            form01.ind_tipo_acomodacao.value            = xml_no[x].getElementsByTagName("IND_ACOMODACAO")[0].childNodes[0].nodeValue;

            if (xml_no[x].getElementsByTagName("IND_ACOMODACAO")[0].childNodes[0].nodeValue == "A"){
               form01.nome_tipo_acomodacao.value               = 'Individual';
            }else if (xml_no[x].getElementsByTagName("IND_ACOMODACAO")[0].childNodes[0].nodeValue == "E"){
               form01.nome_tipo_acomodacao.value               = 'Coletiva';
            }

                var cod_situacao_esp;
            var nome_situacao_esp;
            var nomimagem = '';

            if (xml_no[x].getElementsByTagName("COD_SITUACAO_ESP")[0].childNodes.length > 0) {
                cod_situacao_esp  = LerCampoXML(xml_no[x].getElementsByTagName("COD_SITUACAO_ESP")[0].childNodes[0].nodeValue);
            }

            if (xml_no[x].getElementsByTagName("NOME_SITUACAO_ESP")[0].childNodes.length > 0) {
                nome_situacao_esp = LerCampoXML(xml_no[x].getElementsByTagName("NOME_SITUACAO_ESP")[0].childNodes[0].nodeValue);
            }

            if (xml_no[x].getElementsByTagName("NOM_IMAGEM")[0].childNodes.length > 0) {
                nomimagem         = LerCampoXML(xml_no[x].getElementsByTagName("NOM_IMAGEM")[0].childNodes[0].nodeValue);
            }

            if (nomimagem!="")
            {
               document.all['img_situacao_esp'].style.display = '';
               document.all['img_situacao_esp'].src = '/gen/img/' + nomimagem;;
               document.all['img_situacao_esp'].alt = nome_situacao_esp;
            }

            try{ document.getElementById('Pesquisa_Padrao').style.display  = '';   }catch(e){};
            try{ document.getElementById('Pesquisa_Previa1').style.display  = '';   }catch(e){};
            try{ document.getElementById('Pesquisa_Previa3').style.display  = '';   }catch(e){};

            form01.ind_acao_judicial_cliente.value = LerCampoXML(xml_no[x].getElementsByTagName("INDACAOJUDICIALCLIENTE")[0].childNodes[0].nodeValue);

            if (form01.ind_acao_judicial_cliente.value == "S" && validaPerfil == "1") {
                document.getElementById('Pesquisa_Acao_Judicial_cliente').style.display = '';
            }
            else {
                document.getElementById('Pesquisa_Acao_Judicial_cliente').style.display = 'none';
            }

            if ( form01.num_contrato != "" ){
               try{ document.getElementById('Pesquisa_Previa2').style.display  = '';   }catch(e){}; // pesquisa de previa por titular ainda pendente ( em análise para o caso de vir do CAM )
            }

            try{ document.getElementById('Pesquisa_contrato').style.display  = '';   }catch(e){};

            if ( form01.ind_origem_associado.value == "BD" ) {

               if (xml_no[x].getElementsByTagName("COD_ACAO_TS")[0].text != ""){
               try{document.getElementById('Pesquisa_Judicial').style.display  = '';}catch(e){};
               }
            }

            if (form01.ind_situacao.value=="E" || ComparaData(form01.data_exclusao.value, data_atual, 'DD/MM/YYYY', '<') )
            {
               form01.nom_situacao_associado.style.color = "#FF0000";
               DvSituacao.className = "msg";
            }else{
               //var dataAtual = form01.data_solicitacao.value;
               form01.nom_situacao_associado.style.color = "lightslategray";

                  //if (ComparaData(document.form01.data_inclusao.value, data_atual, 'DD/MM/YYYY', '>'))
               //   form01.nom_situacao_associado.style.color = "red";

               form01.nom_situacao_associado.className   = "camposblocks";
               DvSituacao.className                      = "label_right";
            }

            var vCodPlanoAux;
            if (form01.cod_plano.value != "")
               vCodPlanoAux = form01.cod_plano.value;
            else
               if (form01.cod_plano.value != "")
                     vCodPlanoAux = form01.cod_plano.value;

            if ( form01.cod_ts.value != "" ){
               verificaOcorrencia();
            }

            //verifica se o beneficiário tem email e coloca a opção como default
            if ( xml_no_contato.getElementsByTagName("END_EMAIL")[0].childNodes.length > 0 ) {
               form01.ind_tipo_emissao[0].checked = true;
            }else{
               form01.ind_tipo_emissao[2].checked = true;
            }
			
			//verifica grupo familiar
			retornaQtdFamilia();

         }
          tbConsultaASS.style.display = '';
          tbPrevia.style.display = '';
          tr_conteudo.style.display = '';
      }
      xmlDoc = null
      xml_no = null

      verificaMensagem();

      try{
            form01.cod_origem.focus();
        }catch(e){};
   /*}catch(e){
      document.getElementById('txt_msg').innerHTML     = 'Ocorreu um erro ao recuperar o Beneficiário: ' + e.message;
      document.getElementById('txt_msg').style.display = '';
      form01.num_associado.value = "";
      form01.nome_associado.value   = "";
      form01.num_associado.focus();

      return false;
   }*/

}
//Abre Acao Judicial Cliente ------------------------------------------------------------------------
function AbreAcaoJudicialCliente() {
   var sChamada = '../../pyi/asp/pyi0005a.asp?pt=Prevenção a Fraude';
   sChamada += '&cod_ts=' + form01.cod_ts.value;
   sChamada += '&num_associado=' + form01.num_associado.value;
   sChamada += '&cod_grupo_empresa=' + form01.cod_grupo_empresa.value;
   sChamada += '&cod_ts_contrato='  + form01.cod_ts_contrato.value;
   AbrePesquisa(sChamada, 'Prevenção a Fraude', 'Prevenção a Fraude', 1000, 500, 20, 15, 'S');
}
//---------------------------------
function verificaMensagem(){

    var cp_ass = new cpaint();
    cp_ass.set_transfer_mode('get');
    cp_ass.set_debug(false);
    cp_ass.set_response_type('text');
    cp_ass.set_async(false);

    cp_ass.call('../../rbm/asp/rbm0079f.asp', 'VerificaMensagem', exibeMensagem, form01.num_associado.value, form01.cod_ts.value,form01.cod_ts_tit.value,form01.cod_ts_contrato.value,form01.cod_plano.value,"P");
}
//------------------------------------------------------------------
function exibeMensagem(pXMLD){

    var xmlDoc                = null;
    var xml_no                = null;

    //ABRIR O XML
    //try{
    //Função MultiBrowser
    xmlDoc = loadXMLString(pXMLD);
    xml_no = xmlDoc.getElementsByTagName("ATENDIMENTO");

     // xmlDoc=new ActiveXObject("Microsoft.XMLDOM");
//      xmlDoc.async=false;
 //     xmlDoc.loadXML(pXMLD);
//      xml_no = xmlDoc.getElementsByTagName("ATENDIMENTO");



    for(var x=0; x < xml_no.length; x++)
    {
        if ( xml_no[x].getElementsByTagName("TXT_MENSAGEM")[0].text != "") {
            form01.txt_mensagem.value                    = xml_no[x].getElementsByTagName("TXT_MENSAGEM")[0].text;
            form01.ind_forma_exibicao.value                = xml_no[x].getElementsByTagName("IND_FORMA_EXIBICAO")[0].text;
            ExibeIconMensagem("S");

        } else{
            form01.txt_mensagem.value            = "";
            form01.ind_forma_exibicao.value        = "";
            ExibeIconMensagem("N");
        }
    }


    if ( form01.ind_forma_exibicao.value == 2) {
        form01.aux_tem_msg.value     = "S";
    }
}
//------------------------------------------------------------------
function ExibeIconMensagem(pIndExibe) {

    if (  pIndExibe == "S" ){
        document.getElementById("ico_mensagem").style.display = "";
    }else{
        document.getElementById("ico_mensagem").style.display = "none";
    }

}
//-------------
function LimpaDadosAssociado() {

   form01.num_associado.disabled = false;

   try{tbConsultaASS.style.display                 = 'none';}catch(e){};
   try{tr_conteudo.style.display                 = 'none';}catch(e){};
   try{tbPrevia.style.display                 = 'none';}catch(e){};
   try{document.getElementById('Pesquisa_Padrao').style.display  = 'none';}catch(e){};
   try{ document.getElementById('Pesquisa_Previa1').style.display = 'none';   }catch(e){};
   try{ document.getElementById('Pesquisa_Previa2').style.display = 'none';   }catch(e){};
   try{ document.getElementById('Pesquisa_Previa3').style.display = 'none';   }catch(e){};
   try{ document.getElementById('Pesquisa_Ocorrencia').style.display = 'none';   }catch(e){};
   try{document.all['img_situacao_esp'].style.display = 'none';}catch(e){};
	

   form01.cod_ts.value                   = "";
   form01.num_associado.value            = "";
   form01.nome_associado.value           = "";
   form01.cod_ts_contrato.value          = "";
   form01.dt_ini_vigencia.value          = "";
   form01.num_contrato.value             = "";
   form01.nome_contrato.value            = "";
   form01.nome_contrato_exibicao.value            = "";
   form01.data_nascimento.value        = "";
   form01.idade_associado.value          = "";
   form01.idade_associado_exibicao.value          = "";
   form01.cod_plano.value              = "";
   form01.nome_plano.value              = "";
   form01.nom_situacao_associado.value   = "";
   form01.data_inclusao.value            = "";
   form01.data_exclusao.value            = "";
   form01.ind_situacao.value             = "";
   form01.ind_sexo.value             = "";
   form01.cod_rede.value             = "";
   form01.nom_rede.value             = "";
   form01.nome_operadora.value    = "";
   form01.cod_operadora.value       = "";
   form01.cod_marca.value       = "";
   form01.txt_ddd_fax.value         = "";
   form01.txt_num_fax.value         = "";
   form01.txt_email.value           = "";
   form01.ddd_residencial.value     = "";
   form01.tel_comercial.value       = "";
   form01.ddd_celular.value         = "";
   form01.tel_celular.value          = "";
   form01.ddd_comercial.value       = "";
   form01.tel_comercial.value       = "";
   form01.nome_filial.value           = "";
   form01.cod_inspetoria_ts.value    = "";
   form01.txt_sexo.value  = "";
   form01.tipo_associado.value         = "";
   form01.cod_ts_tit.value         = "";
   form01.cod_entidade_ts_tit.value         = "";
   form01.nome_tipo_acomodacao.value         = "";
   form01.ind_tipo_acomodacao.value         = "";
   form01.ind_origem_associado.value         = "";
   form01.tipo_pessoa_contrato.value         = "";
   form01.num_titular.value         = "";
   form01.nome_titular.value         = "";
   form01.ind_regulamentado.value         = "";
   form01.ind_plano_com_reembolso.value         = "";
   form01.ind_erro_ws.value         = "";
   form01.msg_erro_ws.value         = "";
     
   form01.data_adaptacao.value      = "";
   form01.tem_aditivo.value         = "";
   
	
	
}

function LerCampoXML(pRegistro) {
   if (pRegistro=="-1" || pRegistro=="¦-1" || pRegistro=="|-1")
      return ""
   else
      return pRegistro
}
//------------------------------------------------------------------
function abreAcaoJudicial(){

   var sChamada = '/ASS/ASP/ass0323a.asp';
   sChamada    += '?pt=Ação Judicial';
    sChamada    += '&cod_ts=' + form01.cod_ts.value;
   sChamada    += '&num_associado=' + form01.num_associado.value;
   sChamada    += '&nome_associado=' +  form01.nome_associado.value;
    sChamada    += '&cod_ts_contrato=' + form01.cod_ts_contrato.value;
   sChamada    += '&ajp_ind_tipo=B';
   sChamada    += '&ind_acao=C';
    //sChamada    += '&ind_origem_consulta=C';
   //alert(sChamada);
    AbrePesquisa(sChamada,'Pesquisa_Judicial','Ação Judicial', 780, 500, 5, 5, 'S');

   //if ( form01.ind_tipo_pessoa_contrato.value == 'F' ){
    //    SelecionarItemMenu('ass0323a.asp', 'Ação Judicial', '../../ass/asp/', '86','CB81.1.3.6');
    //}else{
     //   SelecionarItemMenu('ass0323a.asp', 'Ação Judicial', '../../ass/asp/', '86','CB81PJ.1.3.6');
    //}
}
function AbrePesquisaPadrao()
{
   if (form01.ind_origem_associado.value == "WS") {

       /*
        Parâmetros:
      MO = Valor = 9 numéricos (com zero a esquerda se necessário);
        TPES è Tipo de pessoa
         MFS (Pessoa Física Saúde)
         MJS (Pessoa Jurídica Saúde)
        */
        //Formatar com 9 caracteres e zero a esquerda
        var sNumAssociado = form01.num_associado.value;
        if (form01.num_associado.value.length < 9 ) {
            for (var i = 1; i <= parseInt(9-parseInt(form01.num_associado.value.length)); i++) {
                sNumAssociado = "0" + sNumAssociado;
            }
        }

        var sChamada = form01.ts_url_chamada_cam.value;
        sChamada    += '&TxtMotica=' + sNumAssociado;
        sChamada    += '&TipoPessoa=M' + form01.tipo_pessoa_contrato.value + 'S';

        eval('window.open(sChamada,"","width=900,height=600,top=5,left=5,resizable=1,scrollbars=no")');

   }else{

      var sChamada = '/CAL/ASP/CAL0087b.asp';
      sChamada    += '?cod_ts=' + form01.cod_ts.value;
      sChamada    += '&ind_funcao_origem=REE';
      sChamada    += '&pcf=ATB0082&aux_popup=S&ind_origem_consulta=A';
      //sChamada    += '&p_ind_tipo_produto=1';

      AbrePesquisaCrossBrowser(sChamada,'Pesquisa_Padrao','Dados Beneficiário', 1000, 600, 5, 5, 'S');
   }
}

function AbrePesquisaPrevia(sTipo)
{
    var sChamada = '/rbm/asp/rbm0078h_crossbrowser.asp';
    //sChamada    += '?cod_ts=' + form01.cod_ts.value;
    sChamada    += '?num_associado=' + form01.num_associado.value;
    //sChamada    += '&cod_ts_tit=' + form01.cod_ts_tit.value;
    sChamada    += '&num_titular=' + form01.num_titular.value;
    //sChamada    += '&cod_ts_contrato=' + form01.cod_ts_contrato.value;
    sChamada    += '&num_contrato=' + form01.num_contrato.value;
    sChamada    += '&ind_tipo_pesquisa=' + sTipo;
    try{ sChamada    += '&num_previa_reembolso=' + form01.num_reembolso.value; }catch(e){}

    AbrePesquisaCrossBrowser(sChamada,'Pesquisa_Previa','Pesquisa Prévia', 900, 500, 5, 5, 'S');
}
 //------------------------------------------------------------------
    function CalculaValorEmReais()
    {
        var data;
        var moeda;
        var valor;
	

        data = form01.dt_comprovante.value;
        moeda = form01.sigla_moeda.value;
        valor = form01.val_moeda_estrangeira.value;
	
   
        if( form01.ind_internacional[1].checked  == true ){
            if ((data != "") && (moeda != "") && (valor != "")) {
                var cp_ass = new cpaint();
                cp_ass.set_transfer_mode('get');
                cp_ass.set_debug(false);

                cp_ass.call('../../rbm/asp/rbm0020c.asp', 'ConverteMoeda', ExibeValorEmReais, moeda, data,1);
            }
            else {
                form01.val_comprovante.value = "";
            }
        }else{
            form01.val_comprovante.value = valor;
        }

        //form01.val_moeda_estrangeira.value = FormataValorVB(valor);
        form01.val_moeda_estrangeira.value = valor;
    }
    //--------------------------------------------------
function verificaOcorrencia(){

    var v_cod_ts = form01.cod_ts.value;
    var v_cod_ts_contrato = form01.cod_ts_contrato.value;
    var cp_oco = new cpaint();
   cp_oco.set_transfer_mode('get');
   cp_oco.set_debug(false);
   cp_oco.set_response_type('text');
    cp_oco.call('../../rbm/asp/rbm0079f.asp', 'CarregaIndOcorrencia', exibeOcorrencia, v_cod_ts, v_cod_ts_contrato);

}

function exibeOcorrencia(IndOcorrencia){

    try{
        if (IndOcorrencia ==1){
            try{ document.getElementById('Pesquisa_Ocorrencia').style.display  = '';   }catch(e){};
        }else{
            try{ document.getElementById('Pesquisa_Ocorrencia').style.display  = 'none';   }catch(e){};
        }


   }catch(e){};


}


function AbrePesquisaOcorrencia()
{

    var sChamada = '/rbm/asp/rbm0078i.asp';
    sChamada    += '?cod_ts=' + form01.cod_ts.value;
    sChamada    += '&cod_ts_contrato=' + form01.cod_ts_contrato.value;

    AbrePesquisaCrossBrowser(sChamada,'Pesquisa_Ocorrencia','Pesquisa Ocorrência', 900, 500, 5, 5, 'S');
}

function AbrePesquisaContrato()
{
   if (form01.ind_origem_associado.value == "WS") {

       /*
        Parâmetros:
      MO = Valor = 9 numéricos (com zero a esquerda se necessário);
        TPES è Tipo de pessoa
         MFS (Pessoa Física Saúde)
         MJS (Pessoa Jurídica Saúde)
        */
        //Formatar com 9 caracteres e zero a esquerda
        var sNumAssociado = form01.num_associado.value;
        if (form01.num_associado.value.length < 9 ) {
            for (var i = 1; i <= parseInt(9-parseInt(form01.num_associado.value.length)); i++) {
                sNumAssociado = "0" + sNumAssociado;
            }
        }

        var sChamada = form01.ts_url_chamada_cam.value;
        sChamada    += '&TxtMotica=' + sNumAssociado;
        sChamada    += '&TipoPessoa=M' + form01.tipo_pessoa_contrato.value + 'S';

        eval('window.open(sChamada,"","width=900,height=600,top=5,left=5,resizable=1,scrollbars=no")');

   }else{
       var sChamada = '../../ass/asp/ass0056a.asp?pt=Reembolso&pprf=99&pprm=S,S,S,S,N,N&pcf=&pm=11&no=REEMBOLSO&ind_reembolso=S&ind_origem_consulta=A';
      sChamada    += '&cod_plano=' + form01.cod_plano.value + "&ace_consulta=S&cod_ts_contrato="+form01.cod_ts_contrato.value+"&data_inicio_vigencia="+form01.dt_ini_vigencia.value+"";

      AbrePesquisaCrossBrowser(sChamada,'Pesquisa_Contrato','Pesquisa Contrato', 900, 600, 5, 5, 'S');
   }
}

function PesquisaBeneficiario() {

   document.getElementById('txt_msg').innerHTML     = '';
   document.getElementById('txt_msg').style.display = 'none';

   <% if tipo_pesquisa_beneficiario = "CAM" then %>
      var sChamada = '../../gen/asp/gen0171a.asp';
      sChamada += '?indsubmit=False';
      sChamada += '&nome_campo_num=num_associado';
      sChamada += '&nome_campo_cod=cod_ts';
      sChamada += '&nome_campo_nome=nome_associado';
      sChamada += '&abre_modal=N';
      sChamada += '&funcao_executar=CarregaDadosAssociado();'
   <% else %>
      // chamada para pesquisa do Grupo 3
      sChamada = '../../gen/asp/gen0002a.asp';
      sChamada    += '?indsubmit=False';
      sChamada    += '&nome_campo_cod=num_associado&nome_campo_cod_ts=cod_ts&nome_campo_desc=nome_associado';
      sChamada    += '&txt_nome_campo_cod=num_associado&txt_nome_campo_cod_ts=cod_ts&txt_nome_campo_desc=nome_associado' ;//&abre_modal=N'
      sChamada    += '&p_ind_tipo_produto=1';
      sChamada    += '&txt_funcao=CarregaDadosAssociado()';
    <%end if %>

   AbrePesquisa(sChamada, 'Pesquisa_Beneficiario', 'Pesquisa Beneficiário', 1000, 500, 20, 15, 'S')

}

function HistoricoPedido() {
  var strQueryString = '';

  strNumPedido= form01.num_internacao.value;
  strQueryString = strQueryString + "num_pedido=" + strNumPedido + "&indRetornaSituacao=S&<%=session("retorno_pgm_sit")%>";

  AbrePesquisaCrossBrowser('../../atd/asp/atd0021a.asp?pt=Histórico Pedido&ind_forma_abertura=P&botao_voltar=S&' + strQueryString,'','Pedido', 1200,550,50,50,'S');
}


//Exibir/Ocultar grupos de informações
function Expandir(sItem) {
   var sDiv = document.getElementById(sItem);
   var Img  = document.getElementById('img_' + sItem);

   if (sDiv.style.display=='none') {
      sDiv.style.display=''
      Img.src='../../gen/img/btn-up.jpg';
   }else{
      sDiv.style.display='none';
      Img.src='../../gen/img/btn-dn.jpg';
   }
}
function AdicionarAnexo() {
    var sChamda = '';

    sChamda += '../../rbm/asp/rbm0079c.asp';
   sChamda += '?PT=Incluir Anexo';
   AbrePesquisa(sChamda, 'Anexo', 'Inclusão Anexo', 700, 370, 20, 15,'S')
}

function MontaHiddenTela() {
    //RECUPERAR PARAMETROS
    var oElementos = document.form01.elements;
    var iTotal     = oElementos.length;
    var i          = 0;
    var sHTML      = '';
    var sNome;

    while (i<iTotal) {
        if (oElementos[ i ].name != "ind_forma_abertura") {
            if (oElementos[ i ].type == 'text' || oElementos[ i ].type == 'hidden'  || oElementos[ i ].type == 'textarea' || oElementos[ i ].type == 'select-one'){
                valor = trataStr(oElementos[ i ].value);
            sHTML += '<input type="hidden" name="' + oElementos[ i ].name + '" value="' + valor + '">';
         }

            if (oElementos[ i ].type == 'select-multiple') {
                var sSelected = '';
                for (var j=0;j<oElementos[ i ].options.length;j++) {
                    if (oElementos[ i ].options[j].selected) {
                        if (sSelected!='')
                            sSelected += ",";

                        sSelected += oElementos[ i ].options[j].value;
                    }
                }
                sHTML += "<input type='hidden' name='" + oElementos[ i ].name + "' value='" + sSelected + "'>";
            }
            if (oElementos[ i ].type == 'radio') {
                sNome = oElementos[ i ].name;
                while (sNome == oElementos[ i ].name) {
                    if (oElementos[ i ].checked)
                        sHTML += "<input type='hidden' name='" + oElementos[ i ].name + "' value='" + oElementos[ i ].value + "'>";
                    i++;
                }
                i--;
            }
            if (oElementos[ i ].type == 'checkbox') {
                if (oElementos[ i ].checked)
                    sHTML += "<input type='hidden' name='" + oElementos[ i ].name + "' value='" + oElementos[ i ].value + "'>";
            }
        }
        i++;
    }

    return sHTML;
}

// Estas rotinas ficam no próprio asp porque são próprias da função
//--------------------------------------------------------------------------------------

function acao_incluir() { //Somente é chamada com acesso via prestador
   if (form01.ind_executando.value != "S"){
      if (form01.num_associado.value=="") {
         alert("Beneficiário é obrigatório.");
         try{form01.num_associado.focus();}catch(e){};
         return false;
      }

       if (form01.cod_origem.value=="") {
          alert("Origem da solicitação é obrigatória.");
          form01.cod_origem.focus();
          return false;
       }

      if (form01.ind_tipo_reembolso.value=="") {
         alert("Modalidade do reembolso é obrigatória.");
         try{form01.ind_tipo_reembolso.focus();}catch(e){};
         return false;
      }

      if ( form01.tel_residencial.value == "" && form01.tel_celular.value == "" ){
         alert('É obrigatório o preenchimento de pelo menos um dos campos para contato: "Telefone" ou "Celular".');
         try{form01.tel_residencial.focus();}catch(e){};
         return false;
      }

      if (  ( form01.tel_residencial.value  != "" &&  form01.ddd_residencial.value == "" )
         || ( form01.tel_residencial.value  == "" &&  form01.ddd_residencial.value != "" ) ){
         alert('Por favor, informe o telefone residencial completo DDD e número de telefone.');
         try{form01.tel_residencial.focus();}catch(e){};
         return false;
      }

      if (  ( form01.tel_celular.value  != "" &&  form01.ddd_celular.value == "" )
         || ( form01.tel_celular.value  == "" &&  form01.ddd_celular.value != "" ) ){
         alert('Por favor, informe o telefone celular completo DDD e número de telefone.');
         try{form01.tel_celular.focus();}catch(e){};
         return false;
      }

      if (  ( form01.tel_comercial.value  != "" &&  form01.ddd_comercial.value == "" )
         || ( form01.tel_comercial.value  == "" &&  form01.ddd_comercial.value != "" ) ){
         alert('Por favor, informe o telefone comercial completo DDD e número de telefone.');
         try{form01.tel_comercial.focus();}catch(e){};
         return false;
      }

      if (  ( form01.txt_num_fax.value  != "" &&  form01.txt_ddd_fax.value == "" )
         || ( form01.txt_num_fax.value  == "" &&  form01.txt_ddd_fax.value != "" ) ){
         alert('Por favor, informe o fax completo DDD e número de telefone.');
         try{form01.txt_num_fax.focus();}catch(e){};
         return false;
      }

      if ( form01.ind_tipo_emissao[0].checked == true && form01.txt_email.value == "" ) {
         alert('Para emissão por e-mail é obrigatório informar um e-mail de contato');
         try{form01.txt_email.focus();}catch(e){};
         return false;
      }

      if ( form01.ind_tipo_emissao[1].checked == true && form01.txt_num_fax.value == "" ) {
         alert('Para emissão por fax é obrigatório informar o número do fax de contato');
         try{form01.txt_num_fax.focus();}catch(e){};
         return false;
      }

      if ( form01.txt_email.value == "" ){
         if (!confirm("E-mail não informado. Deseja continuar?")) {
            try{form01.txt_email.focus();}catch(e){};
            return false;
         }
       }

       if (form01.ind_tipo_reembolso.value!="1"){
         var qtd_anexo = form01.qtd_anexo.value;
         var qtd_anexo_real = 0;
         if ( qtd_anexo != 0 ){
            for(i = 1;i <= qtd_anexo; i++ ){
               if ( !document.getElementById('ind_excluir_anexo_' + i).checked ){
                  qtd_anexo_real++;
               }
            }
         }

         /*if ( qtd_anexo_real == 0 ){
            alert("Nas modalidades de reembolso diferentes de Consultas, pelo menos um Anexo é obrigatório.");
            return false;
         }*/
       }

	   if (form01.cod_tratamento.value == ""){
		    alert('Tipo Atendimento/Internação é obrigatório.');
			try{document.getElementById('cod_tratamento').focus();}catch(e){};
			return false;
	   }
       if (form01.ind_tipo_reembolso.value == "1"){
           var qtd = document.form01.qtd_procedimento.value;

           try{
               for ( var i = 1; i <= qtd; i++){
                   if ( document.getElementById('cod_especialidade_' + i).value  == "" )
                   {
                       alert('Especialidade não informada.');
                       try{document.getElementById('cod_especialidade_' + i).focus();}catch(e){};
                       return false;
                   }
               }
           }catch(e){};
       }

       form01.ind_executando.value = 'S';
       ChamaGravacao("I");
   }else{
      alert("Aguarde o processamento...");
      return false;
    }
}

// Estas rotinas ficam no próprio asp porque são próprias da função
//--------------------------------------------------------------------------------------
function acao_alterar() { //Somente é chamada com acesso via prestador

   if (form01.ind_executando.value != "S"){
      if (form01.num_associado.value=="") {
         alert("Beneficiário é obrigatório.");
         try{form01.num_associado.focus();}catch(e){};
         return false;
      }

       if (form01.cod_origem.value=="") {
          alert("Origem da solicitação é obrigatória.");
          form01.cod_origem.focus();
          return false;
       }

      if (form01.ind_tipo_reembolso.value=="") {
         alert("Modalidade do reembolso é obrigatória.");
         try{form01.ind_tipo_reembolso.focus();}catch(e){};
         return false;
      }

      if (  ( form01.tel_residencial.value  != "" &&  form01.ddd_residencial.value == "" )
         || ( form01.tel_residencial.value  == "" &&  form01.ddd_residencial.value != "" ) ){
         alert('Por favor, informe o telefone residencial completo DDD e número de telefone.');
         try{form01.tel_residencial.focus();}catch(e){};
         return false;
      }

      if (  ( form01.tel_celular.value  != "" &&  form01.ddd_celular.value == "" )
         || ( form01.tel_celular.value  == "" &&  form01.ddd_celular.value != "" ) ){
         alert('Por favor, informe o telefone celular completo DDD e número de telefone.');
         try{form01.tel_celular.focus();}catch(e){};
         return false;
      }

      if (  ( form01.tel_comercial.value  != "" &&  form01.ddd_comercial.value == "" )
         || ( form01.tel_comercial.value  == "" &&  form01.ddd_comercial.value != "" ) ){
         alert('Por favor, informe o telefone comercial completo DDD e número de telefone.');
         try{form01.tel_comercial.focus();}catch(e){};
         return false;
      }

      if (  ( form01.txt_num_fax.value  != "" &&  form01.txt_ddd_fax.value == "" )
         || ( form01.txt_num_fax.value  == "" &&  form01.txt_ddd_fax.value != "" ) ){
         alert('Por favor, informe o fax completo DDD e número de telefone.');
         try{form01.txt_num_fax.focus();}catch(e){};
         return false;
      }

      if ( form01.ind_tipo_emissao[0].checked == true && form01.txt_email.value == "" ) {
         alert('Para emissão por e-mail é obrigatório informar um e-mail de contato');
         try{form01.txt_email.focus();}catch(e){};
         return false;
      }

      if ( form01.ind_tipo_emissao[1].checked == true && form01.txt_num_fax.value == "" ) {
         alert('Para emissão por fax é obrigatório informar o número do fax de contato');
         try{form01.txt_num_fax.focus();}catch(e){};
         return false;
      }

       if (form01.ind_tipo_reembolso.value!="1"){
         var qtd_anexo = form01.qtd_anexo.value;
         var qtd_anexo_real = 0;
         if ( qtd_anexo != 0 ){
            for(i = 1;i <= qtd_anexo; i++ ){
               if ( !document.getElementById('ind_excluir_anexo_' + i).checked ){
                  qtd_anexo_real++;
               }
            }
         }
         /*
         if ( qtd_anexo_real == 0 ){
            alert("Nas modalidades de reembolso diferentes de Consultas, pelo menos um Anexo é obrigatório.");
            return false;
         }
         */
      }

       if (form01.ind_tipo_reembolso.value == "1"){
           var qtd = document.form01.qtd_procedimento.value;

           try{
               for ( var i = 1; i <= qtd; i++){
                   if ( document.getElementById('cod_especialidade_' + i).value  == "" )
                   {
                       alert('Especialidade não informada.');
                       try{document.getElementById('cod_especialidade_' + i).focus();}catch(e){};
                       return false;
                   }
               }
           }catch(e){};
       }

      form01.ind_executando.value = 'S';
       ChamaGravacao("A");

   }else{
      alert("Aguarde o processamento...");
      return false;
    }

}

function ChamaGravacao(pIndAcao) {
   form01.ind_executando.value = "S";
   MostrarWait();
   var qtd = document.form01.qtd_procedimento.value;

   try{
      for ( var i = 1; i <= qtd; i++){
         if ( document.getElementById('qtd_participante_' + i).value  == "1" )
            replicaValorInformado(i);
      }
   }catch(e){};

   var sHidden          = MontaHiddenTela();
   var div_hidden       = frames['if_execucao'].document.getElementById('div_hidden');
   div_hidden.innerHTML = sHidden;

   var txt_subtitulo    = frames['if_execucao'].document.frm_execucao.PT;
   txt_subtitulo.value  = form01.txt_subtitulo.value;

   var ind_acao    = frames['if_execucao'].document.frm_execucao.ind_acao;
   ind_acao.value  = pIndAcao;

   frames['if_execucao'].document.frm_execucao.action="rbm0078b.asp";
   frames['if_execucao'].document.frm_execucao.submit();
}

function IncluirProcedimento(clicou_botao)
{
    if (form01.cod_motivo_reembolso.value == "") {
        alert("É necessário selecionar o motivo de reembolso antes de adicionar um procedimento");
        LimpaProcedimento(pIndice);
        return false;
    }

   var qtd_procedimento = form01.qtd_procedimento;

   if (parseInt(qtd_procedimento.value) > 0)
   {
       if (document.getElementById('item_medico_' + qtd_procedimento.value).value=="")
       {
           alert("Não é possível incluir um novo procedimento sem que o anterior seja digitado")
           document.getElementById('item_medico_' + qtd_procedimento.value).focus();
           return false;
       }
   }

   qtd_procedimento.value = parseInt(qtd_procedimento.value) + 1;

   var iLinha = qtd_procedimento.value;

   //INCLUIR NO GRID
   var aColunas      = new Array();
   var aColunasDisplay      = new Array();

   //CODIGO
   var i = 0;
   aColunas[i] = '<div style="display: block; min-width: 120px;"><input type="text" id="item_medico_' + iLinha + '" name="item_medico_' + iLinha + '" size="8" maxlength="10" onKeyPress="javascript:MascAlfaNum()" tabindex="1" onChange="CarregaGridProcedimento(' + iLinha + ',\'I\');">';
   aColunas[i] += '&nbsp;<img style="cursor:hand" id="Pesquisa_Item_Medido_' + iLinha + '" name="Pesquisa_Item_Medido_' + iLinha + '" width="16" height="16" src="/gen/mid/lupa.gif" border="0" Title="Pesquisa Procedimentos/Serviços" onClick="javascript:PesquisaProcedimento(' + iLinha + ');" ></div>';
    aColunasDisplay[i] = "";

   //i += 1;
   //aColunas[i] = '<input type="text" name="cod_procedimento_' + iLinha + '" size="10" maxlength="8" onKeyPress="javascript:MascAlfaNum()" OnKeyDown="TeclaEnter();" tabindex="1" readonly class=camposblocks>';

   //DESCRICAO
   i += 1;
   aColunas[i] = '<input type="text" Readonly class=camposblocks id="nome_item_proc_' + iLinha + '" name="nome_item_proc_' + iLinha + '" size="33">';
   aColunas[i] +=    '&nbsp;<img Title="Clique para ver o texto completo." SRC="../../GEN/IMG/folha_1.gif" onclick="mostra_detalhe_proc(' + iLinha + ')" style="cursor:hand">';
   aColunas[i] += '&nbsp;<img id="Pesquisa_deXpara_PB_' + iLinha + '" name="Pesquisa_deXpara_PB_' + iLinha + '" width="20" height="20" src="/gen/img/redirecionar_pb.png" border="0" Title="Item sem De x Para cadastrado">';
   aColunas[i] += '<img id="Pesquisa_deXpara_' + iLinha + '" style="cursor:hand;display:none" name="Pesquisa_deXpara_' + iLinha + '" width="20" height="20" src="/gen/img/redirecionar.png" border="0" Title="Consultar De x Para" onClick="javascript:ConsultarDePara(' + iLinha + ');">';
   aColunas[i] += '<input type="hidden" name="cod_procedimento_' + iLinha + '" id="cod_procedimento_' + iLinha + '" value="">';
   aColunasDisplay[i] = "";
   
   //COBERTURA
   i += 1;
   aColunas[i] = '<center><img id="ind_rol_procedimentos_' + iLinha + '" name="ind_rol_procedimentos_' + iLinha + '"   width="15" height="15"></center>'
   aColunasDisplay[i] = "";

   //DIRETRIZ
   i += 1;
   aColunas[i] = '<center><img id="Img_Diretriz_' + iLinha + '" name="Img_Diretriz_' + iLinha + '" width="15" height="15"></center>'
   aColunasDisplay[i] = "";

   //GENÉTICA
   i += 1;
   aColunas[i] = '<center><img id="ind_genetica_' + iLinha + '" name="ind_genetica_' + iLinha + '" width="15" height="15"></center>'
   aColunasDisplay[i] = "";
		
   //GRUPO ESTATISTICO
   i += 1;
   aColunas[i] = '<input type="text" id="cod_grupo_estatistico_' + iLinha + '" name="cod_grupo_estatistico_' + iLinha + '" size="3" readonly class=camposblocks>'
   aColunasDisplay[i] = "";


   //INDICA SE OCORRERA PAGAMENTO EM DOBRO
   i += 1;
   aColunas[i] = '<input type="checkbox" id="ind_dobra_calculo_' + iLinha + '" name="ind_dobra_calculo_' + iLinha + '" value="S" onclick="CarregaGridProcedimento(' + iLinha + ',\'A\');">';
   aColunas[i] += '<input type="hidden" id="ind_origem_dobra_' + iLinha + '" name="ind_origem_dobra_' + iLinha + '" value="" >';
   aColunasDisplay[i] = ""

   i += 1;
   aColunas[i] = '<input type="checkbox" id="ind_add_anestesista_' + iLinha + '" name="ind_add_anestesista_' + iLinha + '" value="S" style="display:none">';
   aColunas[i] += '<input type="hidden" id="ind_origem_anestesista_' + iLinha + '" name="ind_origem_anestesista_' + iLinha + '" value="">';
   aColunasDisplay[i] = "";

   //MEMORIA CALCULO
   i += 1;
   aColunas[i] = '<img Title="Visualizar a memória do cálculo." id="imgMemoriaCalculo_' + iLinha + '" SRC="../../GEN/IMG/folha3.gif" onclick="AbreMemoriaDeCalculo(' + iLinha + ')" style="cursor:hand">';
   aColunas[i] += '<input type="hidden" id="txt_memoria_calculo_' + iLinha + '" name="txt_memoria_calculo_' + iLinha + '" value="">';
   aColunas[i] += '<input type="hidden" id="xml_memoria_calculo_' + iLinha + '" name="xml_memoria_calculo_' + iLinha + '" value="">';
   aColunasDisplay[i] = "";

   //QUANTIDADE
   i += 1;
   aColunas[i] = '<input type="text" id="qtd_informado_' + iLinha + '" name="qtd_informado_' + iLinha + '" size="3" maxlength="4" onKeyPress="javascript:MascInt();" tabindex="1" onchange="CarregaGridProcedimento(' + iLinha + ',\'A\');" style="TEXT-ALIGN: right">';
   aColunasDisplay[i] = "";

   //SITUAÇÃO
   i += 1;
   aColunas[i] = '<input type="hidden" id="ind_situacao_' + iLinha + '" name="ind_situacao_' + iLinha + '" value="">';
   aColunasDisplay[i] = "none";

   //PRINCIPAL
   i += 1;
   aColunas[i] = '<select id="ind_principal_' + iLinha + '" name="ind_principal_' + iLinha + '" tabindex="1" onchange="VerificaPrincipal(' + iLinha + ');">';
   aColunas[i] += '<option value="N" selected>Não</option>';
   aColunas[i] += '<option value="S">Sim</option>';
   aColunas[i] += '</select>';
   aColunasDisplay[i] = "";

   //VIA
   i += 1;
   aColunas[i]  = '<div id="dvVia_' + iLinha + '">';
   aColunas[i] += '<select id="ind_via_' + iLinha + '" name="ind_via_' + iLinha + '" tabindex="1">';
   aColunas[i] += '  <option value=""></option>';
   aColunas[i] += '</select>';
   aColunas[i] += '</div>';
   aColunasDisplay[i] = "";

   //Doppler
   i += 1;
   aColunas[i]  = '<div id="dvDoppler_' + iLinha + '" >';
   aColunas[i] += '<select id="ind_doppler_' + iLinha + '" name="ind_doppler_' + iLinha + '" tabindex="1">';
   aColunas[i] += '  <option value=""></option>';
   aColunas[i] += '</select>';
   aColunas[i] += '</div>';
   aColunasDisplay[i] = "";

   //VALOR APRESENTADO
   i += 1;
   aColunas[i] = '<input type="text" name="val_apresentado_' + iLinha + '" id="val_apresentado_' + iLinha + '" size="11" maxlength="10" onKeyPress="javascript:MascNum2()" tabindex="1" style="TEXT-ALIGN: right"  >';
   aColunasDisplay[i] = "";

   //VALOR TOTAL
   i += 1;
   aColunas[i] = '<input type="text" name="val_calculado_' + iLinha + '" id="val_calculado_' + iLinha + '" size="11" maxlength="10" onKeyPress="javascript:MascNum()" tabindex="1" style="TEXT-ALIGN: right" Readonly class=camposblocks>';
    aColunas[i] += '<input type="hidden" name="val_calculado_orig_' + iLinha + '" id="val_calculado_orig_' + iLinha + '">';
   aColunasDisplay[i] = "";

   //VALOR TOTAL
   i += 1;
   aColunas[i] = '<input type="text" name="val_reembolsado_' + iLinha + '" id="val_reembolsado_' + iLinha + '" size="11" maxlength="10" onKeyPress="javascript:MascNum()" tabindex="1" style="TEXT-ALIGN: right" onchange="replicaValorInformado(' + iLinha + ')" >';
   aColunasDisplay[i] = "";

   //Desconto de Coparticipação
   i += 1;
   aColunas[i] = '<input type="text" name="val_copart_' + iLinha + '" id="val_copart_' + iLinha + '" size="11" maxlength="10" onKeyPress="javascript:MascNum()" tabindex="1" style="TEXT-ALIGN: right" >';
   aColunasDisplay[i] = "";

   //disabled = ""
   //if ( form01.ind_tipo_reembolso.value == 1 ){
   //   disabled = "disabled class=camposblocks";
   //}

   //EXCLUIR
   i += 1;
   aColunas[i] = '<center><input type="checkbox" id="ind_excluir_' + iLinha + '" name="ind_excluir_' + iLinha + '" value="S"  tabindex="0"></center>';
    aColunasDisplay[i] = "";

   //ESPECIALIDADE
   var disabled_especialidade = ""
   if ( form01.ind_tipo_reembolso.value != 1 ){
     disabled_especialidade = "disabled class=camposblocks";
   }

   i += 1;
   aColunas[i]  = '<div id="dvEspecialidade_' + iLinha + '" ' + disabled_especialidade + '>';
   aColunas[i] += '</div>';
   aColunasDisplay[i] = "";

   //HIDDEN
   aColunas[i] += '<input type="hidden" name="qtd_participante_' + iLinha + '" id="qtd_participante_' + iLinha + '">';
   aColunas[i] += '<input type="hidden" name="ind_cirurgia_' + iLinha + '" id="ind_cirurgia_' + iLinha  + '">';
   aColunas[i] += '<input type="hidden" name="grupo_beneficio_' + iLinha + '" id="grupo_beneficio_' + iLinha  + '">';
   //aColunas[i] += '<input type="hidden" name="cod_grupo_estatistico_' + iLinha + '" id="cod_grupo_estatistico_' + iLinha  + '">';
   aColunas[i] += '<input type="hidden" name="ind_acao_procedimento_'+ iLinha + '"  value="I">';
   aColunas[i] += '<input type="hidden" name="ind_rol_procedimentos_' + iLinha + '" id="ind_rol_procedimentos_' + iLinha + '" >';	
   aColunas[i] += '<input type="hidden" name="ind_diretriz_' + iLinha + '" id="ind_diretriz_' + iLinha + '" >';	
   aColunas[i] += '<input type="hidden" name="ind_genetica_' + iLinha + '" id="ind_genetica_' + iLinha + '" >';	
   aColunasDisplay[i] = "";

   var table = document.all ? document.all['TbProcedimento'] : document.getElementById('TbProcedimento');
   var row = table.insertRow(table.rows.length);

   for (var j = 0; j <= i; j++)
   {
      var cell = row.insertCell(j);
      cell.innerHTML = aColunas[j];
      cell.style.display = aColunasDisplay[j];
   }

   MontaComboEspecialidade(iLinha);

   //INCLUIR NO GRID
   var aCol         = new Array();
   var aColspan   = new Array();
   var x = 0;
   aCol[x] = '&nbsp;';
   aColspan[x] = 0;

   x += 1;
   aCol[x]  = '<table width="100%" border="0" id="tb_dv_participante_' + iLinha + '"><tr>';
   aCol[x] += '<td class="grid_cabec" width="100%"><h1 class="grid_cabec"><label><font align="center" class="label_left"><b>&nbsp;Participante</b></label></h1></td>';
   aCol[x] += '<td class="label_right" ><h1 class="grid_cabec"><img id="img_dv_participante_' + iLinha + '" src="../../gen/img/btn-dn.jpg" width="16" height="12" onClick="Expandir(\'dv_participante_' + iLinha + '\');" style="cursor:hand" title="Clique para exibir Participantes" /></h1></td>';
   aCol[x] += '</tr></table><div id="dv_participante_' + iLinha + '" style="display:none"><fieldset>';
   aCol[x] += '<table border="0" width="100%" align="center" id="tbParticipacao_' + iLinha + '"><tr>';
    aCol[x] += '<td width="10%" class="grid_cabec" align=center><b>Código</td>';
    aCol[x] += '<td width="40%" class="grid_cabec" align=center><b>Nome Funcão</td>';
    aCol[x] += '<td width="10%" class="grid_cabec" align=center><b>% Part.</td>';
   aCol[x] += '<td width="20%" class="grid_cabec" align=center><b>Val. Apresentado (R$)</td>';
    aCol[x] += '<td width="20%" class="grid_cabec" align=center><b>Val. Calculado (R$)</td>';
    aCol[x] += '<td width="25%" class="grid_cabec" align=center><b>Val. Reembolsado (R$)</td>';
    aCol[x] += '<td width="25%" class="grid_cabec" align=center><b>Val. de Coparticipação (R$)</td>';
    aCol[x] += '<td width="10%" class="grid_cabec" align=center><b>Memória Cálculo</td>';
    aCol[x] += '<td width="10%" class="grid_cabec" align=center><b>Desconsiderar</td>';
    aCol[x] += '</tr></table></fieldset></div>';
   aColspan[x] = i;

   var row2 = table.insertRow(table.rows.length);
   row2.style.display = 'none';
   row2.id = 'tr_participacao_' + iLinha;
   for (var j = 0; j <= x; j++)
   {
      var cell = row2.insertCell(j);
      cell.innerHTML = aCol[j];
      if ( aColspan[j] != 0 )
         cell.colSpan = aColspan[j];
   }

   var tipo = form01.ind_tipo_reembolso.value;
   if (tipo == 1)
   {
       document.getElementById('Pesquisa_Item_Medido_' + iLinha).style.display='none';
       document.getElementById('item_medico_' + iLinha).value='10101012';
       CarregaGridProcedimento(iLinha,'I');
       try{
           document.getElementById('item_medico_' + iLinha).className = 'camposblocks';
           document.getElementById('item_medico_' + iLinha).readOnly = true;
           document.getElementById('qtd_informado_' + iLinha).className = 'camposblocks';
           document.getElementById('qtd_informado_' + iLinha).readOnly = true;
           //document.getElementById('ind_excluir_' + iLinha).className = 'camposblocks';
           //document.getElementById('ind_excluir_' + iLinha).disabled = true;
       }catch(e){}
   }

   /*if (dobra_honorario == "S") {
      document.getElementById('dobra_honorario_' + iLinha ).checked = true ;
      document.getElementById('ind_dobra_honorario').checked = true ;
   } else {
      document.getElementById('ind_dobra_honorario').checked = false;
   }*/

   try {
      document.getElementById('item_medico_' + iLinha).focus();
   } catch(e) {};
}
//-------------------------------------------------------------------------------------------
function PesquisaProcedimento(pLinha)
{
   //var parametroProcedimento = 'A';
   sChamada =  '/GEN/ASP/GEN0060a_ora_crossbrowser.asp';
   sChamada += '?ind_tipo_pesquisa=TODOS';
   sChamada += '&indsubmit=False';
   sChamada += '&txt_nome_campo_cod=item_medico_' + pLinha;
   sChamada += '&txt_nome_campo_desc=nome_item_proc_' + pLinha;
   sChamada += '&abre_modal=S';
   sChamada += '&ind_autorizacao=N';
   sChamada += '&ind_rbm_0078=S';
   sChamada += '&ind_brasindice_e_simpro=S';
   sChamada += '&pLinha=' + pLinha;
   sChamada += '&funcao_executar=CarregaGridProcedimento(' + pLinha + ',\\\'A\\\')';

   sChamada += '&data_pesquisa=' + form01.dt_solicitacao.value;

   AbrePesquisaCrossBrowser(sChamada, 'Pesquisa_Todos', 'Procedimento/Serviço', 700, 500, 20, 15, 'S')
}

//Limpar toda a linha do procedimento ------------------------------------------------------------------------
function LimpaProcedimento(pIndice)
{
   try{
      //FAZER
      document.getElementById('item_medico_' + gIndice).value         = "";
      document.getElementById('cod_procedimento_' + gIndice).value    = "";
      document.getElementById('nome_item_proc_' + gIndice).value      = "";
      document.getElementById('qtd_informado_' + gIndice).value       = "";
      document.getElementById('ind_cirurgia_' + gIndice).value      = "";
      document.getElementById('grupo_beneficio_' + gIndice).value      = "";
      document.getElementById('cod_grupo_estatistico_' + gIndice).value      = "";
      document.getElementById('val_apresentado_' + gIndice).value      = "";
      document.getElementById('val_calculado_' + gIndice).value      = "";
      document.getElementById('val_reembolsado_' + gIndice).value    = '';
      document.getElementById('val_copart_' + gIndice).value    = '';

      document.getElementById('ind_dobra_calculo_' + gIndice).checked    = false;
      document.getElementById('ind_dobra_calculo_' + gIndice).style.display = 'none';
      //document.getElementById('ind_exibe_dobra_calc_' + gIndice).value    = '';

      document.getElementById('ind_add_anestesista_' + gIndice).checked    = false;
      document.getElementById('ind_add_anestesista_' + gIndice).style.display = 'none';
      document.getElementById('ind_origem_anestesista_' + gIndice).value    = '';

      document.getElementById('val_reembolsado_' + gIndice).className = '';
      document.getElementById('val_reembolsado_' + gIndice).readOnly = false;
      document.getElementById('imgMemoriaCalculo_' + gIndice).style.display = '';

      try{document.getElementById('Pesquisa_deXpara_PB_' + gIndice).style.display='';} catch(e){};
       try{document.getElementById('Pesquisa_deXpara_' + gIndice).style.display='none';} catch(e){};
      try{ document.getElementById('Img_Erro_' + gIndice).style.display = 'none'; } catch(e){};

      var sTxtCombo = '';
      sTxtCombo += '<select id="ind_via_' + pIndice + '" name="ind_via_' + pIndice + '" tabindex="1">';
      sTxtCombo += '  <option value=""></option>';
      sTxtCombo += '</select>';
      document.getElementById('dvVia_' + pIndice).innerHTML = sTxtCombo;

      var sTxtCombo = '';
      sTxtCombo += '<select id="ind_doppler_' + pIndice + '" name="ind_doppler_' + pIndice + '" tabindex="1">';
      sTxtCombo += '  <option value=""></option>';
      sTxtCombo += '</select>';
      document.getElementById('dvDoppler_' + pIndice).innerHTML = sTxtCombo;

      var cod_especialidade = document.getElementById('cod_especialidade_' + gIndice);
      cod_especialidade.value = "";

      //limpa participacao
      document.getElementById('tr_participacao_' + pIndice).style.display = 'none';
      var table = document.all ? document.all['tbParticipacao_' + gIndice] : document.getElementById('tbParticipacao_' + gIndice);
      var numRows = table.rows.length;
      while ( numRows > 1 ) {
         table.deleteRow(table.rows.length-1);
         numRows = table.rows.length;

      }

      //atualizaPrazo();
   }catch(e){}

}

function atualizaPrazo(pInspetoria){

   if ( pInspetoria == "" ){
      form01.dt_provavel_reembolso.value = "";
      form01.qtd_dias_reembolso.value = "";
      form01.qtd_dias_reemb_uteis.value = "";
      return;
   }

   var cp_item = new cpaint();
   cp_item.set_transfer_mode('get');
   cp_item.set_debug(false);
   //cp_item.set_response_type('text');
   //cp_item.set_async(false); //Faz com que espere o termino deste processo para continuar com o restante do código
   cp_item.call('../../rbm/asp/rbm0079f.asp', 'CarregaPrazo', ExibePrazo, pInspetoria, form01.cod_plano.value);


}
function ExibePrazo(pXML){

    //form01.qtd_dias_reembolso.value = sQtdDias;


   if (pXML == null){
      form01.dt_provavel_reembolso.value="";
      form01.qtd_dias_reembolso.value="";
      form01.qtd_dias_reemb_uteis.value="";
      return;
   }else{
      //Carregar o XML.
      var tabela = pXML.ajaxResponse[0].find_item_by_id('result', 'tabela');

      form01.dt_provavel_reembolso.value= tabela.dataprazo[0].data;
      form01.qtd_dias_reembolso.value=    tabela.qtddiasprazo[0].data;
      form01.qtd_dias_reemb_uteis.value=  tabela.qtddiasuteis[0].data;
      return;

   }

}

//PROCEDIMENTO------------------------------------------------------------------------
function CarregaGridProcedimento(pIndice,pAcao)
{
   gIndice        = pIndice;

   var oCodigo    = document.getElementById('item_medico_' + pIndice);
   var vAux = '';

   document.getElementById('txt_msg').innerHTML = "";
   document.getElementById('txt_msg').style.display='none';

   // variaveis enviadas para o calculo de reembolso
   var num_associado          = document.form01.num_associado.value;
   var cod_ts_contrato          = document.form01.cod_ts_contrato.value;
   var num_contrato         = document.form01.num_contrato.value;
   var cod_plano                = document.form01.cod_plano.value;
   var data_nascimento          = document.form01.data_nascimento.value;
   var ind_sexo                   = document.form01.ind_sexo.value;
   var dt_solicitacao             = document.form01.dt_solicitacao.value;
   var ind_tipo_reembolso       = document.form01.ind_tipo_reembolso.value;
   var qtd_informado             = document.getElementById('qtd_informado_' + pIndice).value;
   var ind_principal             = document.getElementById('ind_principal_' + pIndice).value;
   var ind_via                   = document.getElementById('ind_via_' + pIndice).value;
   var ind_doppler            = document.getElementById('ind_doppler_' + pIndice).value;
   var cod_motivo_reembolso    = document.form01.cod_motivo_reembolso.value;
   var cod_inspetoria_ts       = document.form01.cod_inspetoria_ts_abertura.value;
   var ind_regulamentado       = document.form01.ind_regulamentado.value;
   var cod_operadora             = document.form01.cod_operadora.value;
   var cod_ts_tit             = document.form01.cod_ts_tit.value;
   var num_titular             = document.form01.num_titular.value;

   <%if ( ind_acesso_cam = "S" or txt_modulo = 40 ) and ind_consulta = "S" then%>
      cod_motivo_reembolso = "PLA";
      cod_inspetoria_ts = document.form01.cod_inspetoria_ts.value;
   <%end if%>

   if (oCodigo.value=="")
   {
      LimpaProcedimento(pIndice);
      return false;
   }

   if ( ind_tipo_reembolso == "" ) {
      alert("É necessário selecionar a modalidade de reembolso antes de adicionar um procedimento")
      LimpaProcedimento(pIndice);
      return false;
   }

   if ( cod_motivo_reembolso == "" && ind_tipo_reembolso != "1") {
      alert("É necessário selecionar o motivo de reembolso antes de adicionar um procedimento")
      LimpaProcedimento(pIndice);
      return false;
   }

   document.getElementById('txt_msg').innerHTML = "Aguarde. Carregando dados do item";
   document.getElementById('txt_msg').style.display='';

   var ind_dobra_calculo = '';
   if ( pAcao == 'A' ){
      if ( document.getElementById('ind_dobra_calculo_' + pIndice).checked == true ){
         ind_dobra_calculo = "S";
      }else{
         ind_dobra_calculo = "N";
      }
   }else{
      if ( form01.ind_acomodacao.value == 7 ){ // caso a acomodação seja apartamento
         ind_dobra_calculo = "V"; // Enviado V pois é uma inclusão e o sistema irá verificar as regras
      }else{
         ind_dobra_calculo = "N";
      }
   }

   var ind_add_anestesista = '';
   if ( document.getElementById('ind_origem_anestesista_' + pIndice).value != 'P' ){
      if ( document.getElementById('ind_add_anestesista_' + pIndice).checked == true ){
         ind_add_anestesista = "S";
      }else{
         ind_add_anestesista = "N";
      }
   }

   var cp_item = new cpaint();
   cp_item.set_transfer_mode('get');
   cp_item.set_debug(false);
   cp_item.set_response_type('text');
   cp_item.set_async(false); //Faz com que espere o termino deste processo para continuar com o restante do código

   if ( document.form01.ind_origem_associado.value == "WS"  ) {
      cp_item.call('../../rbm/asp/rbm0079f.asp', 'CarregaProcedimentoCAM', ExibeProcedimento, pIndice, oCodigo.value, num_associado, num_contrato, num_titular,cod_plano, data_nascimento, ind_sexo, dt_solicitacao, ind_tipo_reembolso, qtd_informado, ind_principal, ind_via, ind_doppler, cod_motivo_reembolso, ind_dobra_calculo, ind_add_anestesista, cod_inspetoria_ts, cod_operadora, ind_regulamentado );
   }else{
      cp_item.call('../../rbm/asp/rbm0079f.asp', 'CarregaProcedimento', ExibeProcedimento, pIndice, oCodigo.value, num_associado, cod_ts_contrato, num_contrato, cod_ts_tit, num_titular, cod_plano, data_nascimento, ind_sexo, dt_solicitacao, ind_tipo_reembolso, qtd_informado, ind_principal, ind_via, ind_doppler, cod_motivo_reembolso, ind_dobra_calculo, ind_add_anestesista, cod_inspetoria_ts, cod_operadora, '<%=ind_consulta%>' );
   }
}
//------------------------------------------------------------------------
function ExibeProcedimento(pXML)
{

   var registro            = '';
   var xmlDoc            = null;
   var xml_no            = null;
   var xml_no_funcao      = null;
   var sTxtCombo         = '';
   var ind_via            = '';
   var ind_dopller         = '';
   var ind_principal      = '';
   var sSelected         = '';
   var sQtd                = 0;
   var cod_procedimento_old = "";

   form01.xml_retorna.value = pXML;

   document.getElementById('txt_msg').innerHTML     = '';
   document.getElementById('txt_msg').style.display = 'none';
   //ABRIR O XML
   try{
       if (window.ActiveXObject) {
           xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
           xmlDoc.async = false;
           xmlDoc.loadXML(pXML);
       }
       else {
           parser = new DOMParser();
           xmlDoc = parser.parseFromString(pXML, "text/xml");
       }
   }catch(e){

      document.getElementById('txt_msg').innerHTML     = 'Ocorreu um erro ao recuperar o Item: ' + e.message;
      document.getElementById('txt_msg').style.display = '';

      //LIMPAR TODOS OS DADOS DO PROCEDIMENTO
      LimpaProcedimento(gIndice);

      try{ document.getElementById('item_medico_' + gIndice).focus();}catch(e){}
      return false;
   }

      xml_no = xmlDoc.getElementsByTagName("PROCEDIMENTO");

      for(var x=0; x < xml_no.length; x++) {

         if (xml_no[x].getElementsByTagName("COD_RETORNO")[0].childNodes[0].nodeValue =="9") { //OCORREU ALGUM PROBLEMA AO RECUPERAR O ITEM

            //LIMPAR TODOS OS DADOS DO PROCEDIMENTO
            LimpaProcedimento(gIndice);

            document.getElementById('txt_msg').innerHTML = xml_no[x].getElementsByTagName("MSG_RETORNO")[0].childNodes[0].nodeValue;
            document.getElementById('txt_msg').style.display = '';

            try {document.getElementById('item_medico_' + gIndice).focus();} catch (e) {}
            return false;

         }else{ //ACHOU O ITEM
            cod_procedimento_old = document.getElementById('cod_procedimento_' + gIndice).value;

            //document.getElementById('item_medico_' + gIndice).value         = xml_no[x].getElementsByTagName("CODIGO")[0].text;
            document.getElementById('cod_procedimento_' + gIndice).value    = xml_no[x].getElementsByTagName("CODIGO_PARA")[0].childNodes[0].nodeValue;
            document.getElementById('nome_item_proc_' + gIndice).value      = xml_no[x].getElementsByTagName("DESCRICAO")[0].childNodes[0].nodeValue;
			
			document.getElementById('ind_rol_procedimentos_'+ gIndice).setAttribute('src',xml_no[x].getElementsByTagName("IND_ROL_PROCEDIMENTOS")[0].childNodes[0].nodeValue   == 'S' ? '/gen/img/check.gif' : '/gen/img/TecnicaAdm.png');
			document.getElementById('Img_Diretriz_'+ gIndice).setAttribute('src', xml_no[x].getElementsByTagName("IND_DIRETRIZ")[0].childNodes[0].nodeValue 			  == 'S' ? '/gen/img/check.gif' : '/gen/img/TecnicaAdm.png');
			document.getElementById('ind_diretriz_'+ gIndice).value = xml_no[x].getElementsByTagName("IND_DIRETRIZ")[0].childNodes[0].nodeValue ;
			document.getElementById('ind_genetica_'+ gIndice).setAttribute('src', xml_no[x].getElementsByTagName("IND_GENETICA")[0].childNodes[0].nodeValue 			  == 'S' ? '/gen/img/check.gif' : '/gen/img/TecnicaAdm.png');
			
            if (xml_no[x].getElementsByTagName("QTD_INFORMADO")[0].childNodes.length > 0) {
                document.getElementById('qtd_informado_' + gIndice).value       = xml_no[x].getElementsByTagName("QTD_INFORMADO")[0].childNodes[0].nodeValue;
            }

            if (xml_no[x].getElementsByTagName("IND_CIRURGIA")[0].childNodes.length > 0) {
                document.getElementById('ind_cirurgia_' + gIndice).value      = xml_no[x].getElementsByTagName("IND_CIRURGIA")[0].childNodes[0].nodeValue;
            }

            if (xml_no[x].getElementsByTagName("GRUPO_BENEFICIO")[0].childNodes.length > 0) {
                document.getElementById('grupo_beneficio_' + gIndice).value      = xml_no[x].getElementsByTagName("GRUPO_BENEFICIO")[0].childNodes[0].nodeValue;
            }


            if (xml_no[x].getElementsByTagName("COD_GRUPO_ESTATISTICO")[0].childNodes.length > 0) {
                document.getElementById('cod_grupo_estatistico_' + gIndice).value      = xml_no[x].getElementsByTagName("COD_GRUPO_ESTATISTICO")[0].childNodes[0].nodeValue;
            }
			
            //valida se exibe checkbox de paga em dobro
            //document.getElementById('ind_exibe_dobra_calc_' + gIndice).value = xml_no[x].getElementsByTagName("IND_EXIBE_DOBRA_CALC")[0].text;
            //if ( xml_no[x].getElementsByTagName("IND_EXIBE_DOBRA_CALC")[0].text != "S" ){
            //   document.getElementById('ind_dobra_calculo_' + gIndice).style.display='none';
            //   document.getElementById('ind_dobra_calculo_' + gIndice).checked = false;
            //}else{
                if ( xml_no[x].getElementsByTagName("IND_DOBRA_CALCULO")[0].childNodes[0].nodeValue == "S" ){
                  document.getElementById('ind_dobra_calculo_' + gIndice).checked = true;
               }else{
                  document.getElementById('ind_dobra_calculo_' + gIndice).checked = false;
               }
               document.getElementById('ind_dobra_calculo_' + gIndice).style.display='';
            //}

            //valida se exibe checkbox de adicionar anestesista
            if (xml_no[x].getElementsByTagName("IND_ORIGEM_ANESTESISTA")[0].childNodes.length > 0) {
               document.getElementById('ind_origem_anestesista_' + gIndice).value = xml_no[x].getElementsByTagName("IND_ORIGEM_ANESTESISTA")[0].childNodes[0].nodeValue;
               if ( xml_no[x].getElementsByTagName("IND_ORIGEM_ANESTESISTA")[0].childNodes[0].nodeValue == "P" ){
                   document.getElementById('ind_add_anestesista_' + gIndice).style.display='none';
                   document.getElementById('ind_add_anestesista_' + gIndice).checked = false;
               }else{
                   if ( xml_no[x].getElementsByTagName("IND_ADD_ANESTESISTA")[0].childNodes[0].nodeValue == "S" ){
                       document.getElementById('ind_add_anestesista_' + gIndice).checked = true;
                   }else{
                       document.getElementById('ind_add_anestesista_' + gIndice).checked = false;
                   }
                   document.getElementById('ind_add_anestesista_' + gIndice).style.display='';
               }
            }

            //valida se exibe de para
            try{document.getElementById('Pesquisa_deXpara_PB_' + gIndice).style.display='';} catch(e){};
            try{document.getElementById('Pesquisa_deXpara_' + gIndice).style.display='none';} catch(e){};
            if (document.getElementById('item_medico_' + gIndice).value != ""
             && document.getElementById('cod_procedimento_' + gIndice).value != document.getElementById('item_medico_' + gIndice).value) {
               try{document.getElementById('Pesquisa_deXpara_PB_' + gIndice).style.display='none';} catch(e){};
               try{document.getElementById('Pesquisa_deXpara_' + gIndice).style.display='';} catch(e){};
            }

            MontaComboPrincipal(gIndice);
            MontaComboDoppler(gIndice,document.getElementById('cod_grupo_estatistico_' + gIndice).value);

            //PARTICIPACAO
            xml_no_funcao = xml_no[x].getElementsByTagName("FUNCAO");

            if (cod_procedimento_old != document.getElementById('cod_procedimento_' + gIndice).value || cod_procedimento_old == "" ){
               var table = document.all ? document.all['tbParticipacao_' + gIndice] : document.getElementById('tbParticipacao_' + gIndice);
               var numRows = table.rows.length;

               while ( numRows > 1 ) {
                  table.deleteRow(table.rows.length - 1);
                  numRows = table.rows.length;
               }
            }

            if (xml_no_funcao.length>0 ) {
               var ind_funcao, nome_funcao, percentual, valor, valor_original, valor_copart, valor_apresenado;

               for(var k=0; k < xml_no_funcao.length; k++) {
				
                   ind_funcao  = xml_no_funcao[k].getElementsByTagName("COD_FUNCAO")[0].childNodes[0].nodeValue;
                   nome_funcao = xml_no_funcao[k].getElementsByTagName("NOME_FUNCAO")[0].childNodes[0].nodeValue;
                   if (xml_no_funcao[k].getElementsByTagName("PERC_FUNCAO")[0].childNodes.length > 0) {
                       percentual  = xml_no_funcao[k].getElementsByTagName("PERC_FUNCAO")[0].childNodes[0].nodeValue;
                   }
                   else {
                       percentual = 0;
                   }
                   percentual_label  = xml_no_funcao[k].getElementsByTagName("PERC_FUNCAO_LABEL")[0].childNodes[0].nodeValue;
                   valor       = xml_no_funcao[k].getElementsByTagName("VAL_CALCULADO")[0].childNodes[0].nodeValue;
                   valor_copart  = 0;
                   val_apresentado = 0;

                  kFuncao = k+1

                  if (cod_procedimento_old != document.getElementById('cod_procedimento_' + gIndice).value || cod_procedimento_old == "" ){
                     IncluirParticipante(gIndice, kFuncao, ind_funcao, nome_funcao, percentual, percentual_label, valor);
                  }else{
                     document.getElementById('ind_funcao_' + gIndice + '_' + kFuncao).value                = ind_funcao;
                     document.getElementById('lbl_cod_funcao_' + gIndice + '_' + kFuncao).innerHTML             = ind_funcao;
                     document.getElementById('nome_funcao_' + gIndice + '_' + kFuncao).value             = nome_funcao;
                     document.getElementById('lbl_nome_funcao_' + gIndice + '_' + kFuncao).innerHTML          = nome_funcao;
                     document.getElementById('pct_participacao_' + gIndice + '_' + kFuncao).value          = percentual;
                     document.getElementById('lbl_pct_participacao_' + gIndice + '_' + kFuncao).innerHTML       = percentual_label;
                     document.getElementById('val_apresentado_' + gIndice + '_' + kFuncao).innerHTML          = val_apresentado;
                     document.getElementById('lbl_val_calculado_' + gIndice + '_' + kFuncao).innerHTML          = valor;
                     document.getElementById('val_calculado_' + gIndice + '_' + kFuncao).value             = valor;
                     document.getElementById('val_calculado_orig_' + gIndice + '_' + kFuncao).value          = valor;
                     document.getElementById('val_informado_' + gIndice + '_' + kFuncao).value             = valor;
                     document.getElementById('val_copart_' + gIndice + '_' + kFuncao).value             = valor_copart;
                  }

                  if (xml_no_funcao[k].getElementsByTagName("XML_MEMORIA_CALCULO")[0].xml != undefined) {
                      document.getElementById('xml_memoria_calculo_' + gIndice + '_' + kFuncao).value = xml_no_funcao[k].getElementsByTagName("XML_MEMORIA_CALCULO")[0].xml;
                  }
                  else {
                      var memoria = xml_no_funcao[k].getElementsByTagName("XML_MEMORIA_CALCULO")[0];
                      var xmlMemoria = new XMLSerializer().serializeToString(memoria);
                      document.getElementById('xml_memoria_calculo_' + gIndice + '_' + kFuncao).value = xmlMemoria;
                  }

                  document.getElementById('txt_memoria_calculo_' + gIndice + '_' + kFuncao).value = getElementValueByTag(xml_no_funcao[k], "TXT_MEMORIA_CALCULO", '');
                  document.getElementById('cod_reembolso_' + gIndice + '_' + kFuncao).value = getElementValueByTag(xml_no_funcao[0], "COD_REEMBOLSO", '');

                  document.getElementById('cod_grupo_estatistico_' + gIndice + '_' + kFuncao).value = getElementValueByTag(xml_no_funcao[0], "COD_GRUPO_ESTATISTICO", 0);

                  document.getElementById('ind_tipo_composicao_' + gIndice + '_' + kFuncao).value = getElementValueByTag(xml_no_funcao[0], "IND_TIPO_COMPOSICAO", '');

                  document.getElementById('val_cotacao_rb_' + gIndice + '_' + kFuncao).value = getElementValueByTag(xml_no_funcao[0], "VAL_COTACAO_RB", 0);

                  document.getElementById('sigla_tabela_rb_' + gIndice + '_' + kFuncao).value = getElementValueByTag(xml_no_funcao[0], "SIGLA_TABELA_RB", '');

                  if (xml_no_funcao[0].getElementsByTagName("SIGLA_TABELA_TAXAS")[0].childNodes.length > 0) {
                      document.getElementById('sigla_tabela_taxas_' + gIndice + '_' + kFuncao).value = xml_no_funcao[0].getElementsByTagName("SIGLA_TABELA_TAXAS")[0].childNodes[0].nodeValue;
                  }

                  if (xml_no_funcao[0].getElementsByTagName("VAL_COTACAO_TAXA")[0].childNodes.length > 0) {
                      document.getElementById('val_cotacao_taxa_' + gIndice + '_' + kFuncao).value = xml_no_funcao[0].getElementsByTagName("VAL_COTACAO_TAXA")[0].childNodes[0].nodeValue;
                  }

                  if (xml_no_funcao[0].getElementsByTagName("PCT_CIRU_MULTIPLA")[0].childNodes.length > 0) {
                      document.getElementById('pct_cirurgia_multipla_' + gIndice + '_' + kFuncao).value = xml_no_funcao[0].getElementsByTagName("PCT_CIRU_MULTIPLA")[0].childNodes[0].nodeValue;
                  }

                  if (xml_no_funcao[0].getElementsByTagName("COD_PORTE_RB")[0].childNodes.length > 0) {
                      document.getElementById('cod_porte_rb_' + gIndice + '_' + kFuncao).value = xml_no_funcao[0].getElementsByTagName("COD_PORTE_RB")[0].childNodes[0].nodeValue;
                  }

                  if (xml_no_funcao[0].getElementsByTagName("QTD_VEZES_TABELA")[0].childNodes.length > 0) {
                      document.getElementById('qtd_vezes_tabela_' + gIndice + '_' + kFuncao).value = xml_no_funcao[0].getElementsByTagName("QTD_VEZES_TABELA")[0].childNodes[0].nodeValue;
                  }

                  if (xml_no_funcao[0].getElementsByTagName("QTD_PRAZO_DIAS")[0].childNodes.length > 0) {
                      document.getElementById('qtd_prazo_dias_' + gIndice + '_' + kFuncao).value = xml_no_funcao[0].getElementsByTagName("QTD_PRAZO_DIAS")[0].childNodes[0].nodeValue;
                  }

                  if (xml_no_funcao[0].getElementsByTagName("COD_CONCESSAO")[0].childNodes.length > 0) {
                      document.getElementById('cod_concessao_' + gIndice + '_' + kFuncao).value = xml_no_funcao[0].getElementsByTagName("COD_CONCESSAO")[0].childNodes[0].nodeValue;
                  }

                  if (xml_no_funcao[0].getElementsByTagName("PCT_RECIBO")[0].childNodes.length > 0) {
                      document.getElementById('pct_recibo_' + gIndice + '_' + kFuncao).value = xml_no_funcao[0].getElementsByTagName("PCT_RECIBO")[0].childNodes[0].nodeValue;
                  }

                  if (xml_no_funcao[0].getElementsByTagName("SIGLA_MOEDA")[0].childNodes.length > 0) {
                      document.getElementById('sigla_moeda_' + gIndice + '_' + kFuncao).value = xml_no_funcao[0].getElementsByTagName("SIGLA_MOEDA")[0].childNodes[0].nodeValue;
                  }

                  if (xml_no_funcao[0].getElementsByTagName("VAL_LIMITE")[0].childNodes.length > 0) {
                      document.getElementById('val_limite_' + gIndice + '_' + kFuncao).value = xml_no_funcao[0].getElementsByTagName("VAL_LIMITE")[0].childNodes[0].nodeValue;
                  }

                  if (xml_no_funcao[0].getElementsByTagName("VAL_FIXO")[0].childNodes.length > 0) {
                      document.getElementById('val_fixo_' + gIndice + '_' + kFuncao).value = xml_no_funcao[0].getElementsByTagName("VAL_FIXO")[0].childNodes[0].nodeValue;
                  }

                  if ( document.getElementById('dv_participante_' + gIndice).style.display == 'none' ){
                     Expandir('dv_participante_' + gIndice );
                  }

               }

               if ( xml_no_funcao.length>1 ){
                  document.getElementById('tr_participacao_' + gIndice).style.display = '';
                  document.getElementById('val_reembolsado_' + gIndice).className = 'camposblocks';
                  document.getElementById('imgMemoriaCalculo_' + gIndice).style.display = 'none';
                  document.getElementById('txt_memoria_calculo_' + gIndice).value = '';
                  document.getElementById('xml_memoria_calculo_' + gIndice).value = '';

               }else{
                  document.getElementById('tr_participacao_' + gIndice).style.display = 'none';
                  document.getElementById('val_reembolsado_' + gIndice).className = '';
                  document.getElementById('imgMemoriaCalculo_' + gIndice).style.display = '';
                  document.getElementById('txt_memoria_calculo_' + gIndice).value = document.getElementById('txt_memoria_calculo_' + gIndice + '_' + kFuncao).value;
                  document.getElementById('xml_memoria_calculo_' + gIndice).value = document.getElementById('xml_memoria_calculo_' + gIndice + '_' + kFuncao).value;
               }

            }else{
               //caso ele volte sem função adiciona uma em branco.
               k = 1;
               if (cod_procedimento_old != document.getElementById('cod_procedimento_' + gIndice).value || cod_procedimento_old == "" ){
                  IncluirParticipante(gIndice, 1, '', '', '', '', '0,00');
               }

            }
						
            xml_no_funcao = null;
         }
      }

      xmlDoc = null;
      xml_no = null;

      if( k > 0 ){
         document.getElementById('qtd_participante_' + gIndice).value   = k;
      }

      SomaParticipacao(gIndice);

}

function getElementValueByTag(obj, tag, defaultValue) {
    if (obj && tag) {
        var node = obj.getElementsByTagName(tag);
        if (node && node.length > 0) {
            var child = node[0].childNodes;
            if (child && child.length > 0) {
                return child[0].nodeValue ? child[0].nodeValue : defaultValue;
            }
        }
    }

    return defaultValue;
}

function mostra_detalhe_anexo(detalhe) {
   try{
      if(false == janela.closed){
         janela.close ();
      }
   }catch(e){}
   janela = window.open('','teste','location=no,menubar=no,directories=no,resizable=no,scrollbars=no,status=no,toolbar=no,width=400,height=300');
   janela.document.write('<textarea readonly cols=43 rows=16 name=txt_descricao>');
   janela.document.write(detalhe);
   janela.document.write('</textarea>');
}

function IncluirParticipante(pIndiceItem, pIndiceFuncao, pCodFuncao, pNomeFuncao, pPercentual, pPercentualLabel, pValorOriginal)
{
   //INCLUIR NO GRID
   var aCol         = new Array();
   var aColStyle      = new Array();
   var displayExcluir = "";
   var checkedDefault = "";
   var disabledDefault = "";

   if ( pCodFuncao == "00" || pCodFuncao == "12" ){
      displayExcluir = " style='display=none' ";
   }

   if ( pCodFuncao == "05" || pCodFuncao == "07" || pCodFuncao == "13" ){
      checkedDefault = " checked ";
      disabledDefault   = " readonly class=camposblocks ";
   }

   //IND_FUNCAO
   var i = 0;
   aCol[i] = '<center><label id="lbl_cod_funcao_' + pIndiceItem + '_' + pIndiceFuncao + '">' + pCodFuncao + '</label></center>';
   aCol[i] += '<input type="hidden" id="ind_funcao_' + pIndiceItem + '_' + pIndiceFuncao + '" name="ind_funcao_' + pIndiceItem + '_' + pIndiceFuncao + '" value="' + pCodFuncao + '">';

   aColStyle[i] = 'grid_center';

   //NOME_FUNCAO
   i += 1;
   aCol[i] = '<label id="lbl_nome_funcao_' + pIndiceItem + '_' + pIndiceFuncao + '">' + pNomeFuncao + '</label>';
   aCol[i] += '<input type="hidden" id="nome_funcao_' + pIndiceItem + '_' + pIndiceFuncao + '" name="nome_funcao_' + pIndiceItem + '_' + pIndiceFuncao + '" value="' + pNomeFuncao + '">';
   aColStyle[i] = 'grid_left';

   //% PARTICIPAÇÃO
   i += 1;
   aCol[i] = '<label id="lbl_pct_participacao_' + pIndiceItem + '_' + pIndiceFuncao + '">' + pPercentualLabel + '</label>';
   aCol[i] += '<input type="hidden" id="pct_participacao_' + pIndiceItem + '_' + pIndiceFuncao + '" name="pct_participacao_' + pIndiceItem + '_' + pIndiceFuncao + '" value="' + pPercentual + '">';
   aColStyle[i] = 'grid_right';

   //VALOR APRESENTADO
   i += 1;
   aCol[i] = '<input type="text" id="val_apresentado_' + pIndiceItem + '_' + pIndiceFuncao + '" name="val_apresentado_' + pIndiceItem + '_' + pIndiceFuncao + '" value="' + "00.00" + '" size="14" maxlength="10" onKeyPress="javascript:MascNum()" tabindex="1" style="TEXT-ALIGN: right" onchange="SomaParticipacao(' + pIndiceItem + ');" '+ disabledDefault +'>';
   aColStyle[i] = 'grid_right';

   //VALOR CALCULADO
   i += 1;
   aCol[i] = '<label id="lbl_val_calculado_' + pIndiceItem + '_' + pIndiceFuncao + '">' + pValorOriginal + '</label>';
   aCol[i] += '<input type="hidden" id="val_calculado_' + pIndiceItem + '_' + pIndiceFuncao + '" name="val_calculado_' + pIndiceItem + '_' + pIndiceFuncao + '" value="' + pValorOriginal + '">';
   aCol[i] += '<input type="hidden" id="val_calculado_orig_' + pIndiceItem + '_' + pIndiceFuncao + '" name="val_calculado_orig_' + pIndiceItem + '_' + pIndiceFuncao + '" value="' + pValorOriginal + '">';
   aColStyle[i] = 'grid_right';

   //VALOR INFORMADO
   i += 1;
   aCol[i] = '<input type="text" id="val_informado_' + pIndiceItem + '_' + pIndiceFuncao + '" name="val_informado_' + pIndiceItem + '_' + pIndiceFuncao + '" value="' + pValorOriginal + '" size="14" maxlength="10" onKeyPress="javascript:MascNum()" tabindex="1" style="TEXT-ALIGN: right" onchange="SomaParticipacao(' + pIndiceItem + ');" '+ disabledDefault +'>';
   aColStyle[i] = 'grid_right';

   //VALOR COPART
   i += 1;
   aCol[i] = '<input type="text" id="val_Copart_' + pIndiceItem + '_' + pIndiceFuncao + '" name="val_Copart_' + pIndiceItem + '_' + pIndiceFuncao + '" value="' + "00.00" + '" size="14" maxlength="10" onKeyPress="javascript:MascNum()" tabindex="1" style="TEXT-ALIGN: right" '+ disabledDefault +'>';
   aColStyle[i] = 'grid_right';

   //MEMORIA CALCULO
   i += 1;
   aCol[i] = '<img Title="Visualizar a memória do cálculo." SRC="../../GEN/IMG/folha3.gif" onclick="AbreMemoriaDeCalculo(\'' + pIndiceItem + '_' + pIndiceFuncao +  '\')" style="cursor:hand">';
   aCol[i] += '<input type="hidden" id="txt_memoria_calculo_' + pIndiceItem + '_' + pIndiceFuncao +  '" name="txt_memoria_calculo_' + pIndiceItem + '_' + pIndiceFuncao +  '" value="">';
   aCol[i] += '<input type="hidden" id="xml_memoria_calculo_' + pIndiceItem + '_' + pIndiceFuncao +  '" name="xml_memoria_calculo_' + pIndiceItem + '_' + pIndiceFuncao +  '" value="">';
   aColStyle[i] = 'grid_center';

   //EXCLUSAO
   i += 1;
   aCol[i] = '<center><input type="checkbox" id="ind_excluir_' + pIndiceItem + '_' + pIndiceFuncao + '" name="ind_excluir_' + pIndiceItem + '_' + pIndiceFuncao + '" value="S" tabindex="1" onclick="HabDesabLinhaParticipacao(' + pIndiceItem + ',' + pIndiceFuncao + ');" ' + displayExcluir + checkedDefault+'></center>';
   aColStyle[i] = 'grid_center';

   aCol[i] += '<input type="hidden" name="cod_grupo_estatistico_' + pIndiceItem + '_' + pIndiceFuncao + '" id="cod_grupo_estatistico_' + pIndiceItem + '_' + pIndiceFuncao + '">';
    aCol[i] += '<input type="hidden" name="ind_tipo_composicao_' + pIndiceItem + '_' + pIndiceFuncao + '" id="ind_tipo_composicao_' + pIndiceItem + '_' + pIndiceFuncao + '">';
    aCol[i] += '<input type="hidden" name="val_cotacao_rb_' + pIndiceItem + '_' + pIndiceFuncao + '" id="val_cotacao_rb_' + pIndiceItem + '_' + pIndiceFuncao + '">';
    aCol[i] += '<input type="hidden" name="sigla_tabela_rb_' + pIndiceItem + '_' + pIndiceFuncao + '" id="sigla_tabela_rb_' + pIndiceItem + '_' + pIndiceFuncao + '">';
    aCol[i] += '<input type="hidden" name="cod_porte_rb_' + pIndiceItem + '_' + pIndiceFuncao + '" id="cod_porte_rb_' + pIndiceItem + '_' + pIndiceFuncao + '">';
    aCol[i] += '<input type="hidden" name="sigla_tabela_taxas_' + pIndiceItem + '_' + pIndiceFuncao + '" id="sigla_tabela_taxas_' + pIndiceItem + '_' + pIndiceFuncao + '">';
    aCol[i] += '<input type="hidden" name="val_cotacao_taxa_' + pIndiceItem + '_' + pIndiceFuncao + '" id="val_cotacao_taxa_' + pIndiceItem + '_' + pIndiceFuncao + '">';
    aCol[i] += '<input type="hidden" name="pct_cirurgia_multipla_' + pIndiceItem + '_' + pIndiceFuncao + '" id="pct_cirurgia_multipla_' + pIndiceItem + '_' + pIndiceFuncao + '">';
    aCol[i] += '<input type="hidden" name="qtd_vezes_tabela_' + pIndiceItem + '_' + pIndiceFuncao + '" id="qtd_vezes_tabela_' + pIndiceItem + '_' + pIndiceFuncao + '">';
    aCol[i] += '<input type="hidden" name="qtd_prazo_dias_' + pIndiceItem + '_' + pIndiceFuncao + '" id="qtd_prazo_dias_' + pIndiceItem + '_' + pIndiceFuncao + '">';
    aCol[i] += '<input type="hidden" name="sigla_moeda_' + pIndiceItem + '_' + pIndiceFuncao + '" id="sigla_moeda_' + pIndiceItem + '_' + pIndiceFuncao + '">';
    aCol[i] += '<input type="hidden" name="cod_concessao_' + pIndiceItem + '_' + pIndiceFuncao + '" id="cod_concessao_' + pIndiceItem + '_' + pIndiceFuncao + '">';
    aCol[i] += '<input type="hidden" name="cod_reembolso_' + pIndiceItem + '_' + pIndiceFuncao + '" id="cod_reembolso_' + pIndiceItem + '_' + pIndiceFuncao + '">';
    aCol[i] += '<input type="hidden" name="pct_recibo_' + pIndiceItem + '_' + pIndiceFuncao + '" id="pct_recibo_' + pIndiceItem + '_' + pIndiceFuncao + '">';
    aCol[i] += '<input type="hidden" name="val_fixo_' + pIndiceItem + '_' + pIndiceFuncao + '" id="val_fixo_' + pIndiceItem + '_' + pIndiceFuncao + '">';
    aCol[i] += '<input type="hidden" name="val_limite_' + pIndiceItem + '_' + pIndiceFuncao + '" id="val_limite_' + pIndiceItem + '_' + pIndiceFuncao + '">';

   var ult_num_seq_item = form01.ult_num_seq_item;
    ult_num_seq_item.value = parseInt(ult_num_seq_item.value)+1;
    aCol[i] += '<input type="hidden" name="num_seq_item_' + pIndiceItem + '_' + pIndiceFuncao + '"  value="' + ult_num_seq_item.value + '">';

   var table = document.all ? document.all['tbParticipacao_' + pIndiceItem] : document.getElementById('tbParticipacao_' + pIndiceItem);
   var row = table.insertRow(table.rows.length);
   for (var j = 0; j <= i; j++)
   {
      var cell = row.insertCell(j);
      cell.innerHTML = aCol[j];
      if (parseInt(pIndiceFuncao) % 2 == 0)
         cell.className = aColStyle[j];
      else
         cell.className = aColStyle[j] + "02";
   }
}
//--------------------------------
function HabDesabLinhaParticipacao(pIndiceItem, pIndiceFuncao)
{
   if (document.getElementById('ind_excluir_' + pIndiceItem + '_' + pIndiceFuncao).checked!=true)
   {
      document.getElementById('val_informado_' + pIndiceItem + '_' + pIndiceFuncao).readOnly = false;
      document.getElementById('val_informado_' + pIndiceItem + '_' + pIndiceFuncao).enabled = true;
      document.getElementById('val_informado_' + pIndiceItem + '_' + pIndiceFuncao).className = "";

      document.getElementById('val_apresentado_' + pIndiceItem + '_' + pIndiceFuncao).readOnly = false;
      document.getElementById('val_apresentado_' + pIndiceItem + '_' + pIndiceFuncao).enabled = true;
      document.getElementById('val_apresentado_' + pIndiceItem + '_' + pIndiceFuncao).className = "";
   }else{
      document.getElementById('val_informado_' + pIndiceItem + '_' + pIndiceFuncao).readOnly = true;
      document.getElementById('val_informado_' + pIndiceItem + '_' + pIndiceFuncao).enabled = false;
      document.getElementById('val_informado_' + pIndiceItem + '_' + pIndiceFuncao).className = "camposblocks";

      document.getElementById('val_apresentado_' + pIndiceItem + '_' + pIndiceFuncao).readOnly = true;
      document.getElementById('val_apresentado_' + pIndiceItem + '_' + pIndiceFuncao).enabled = false;
      document.getElementById('val_apresentado_' + pIndiceItem + '_' + pIndiceFuncao).className = "camposblocks";
   }

   SomaParticipacao(pIndiceItem);
}
//--------------------------------
function ExibeInscricaoFiscal(siglaProf) {
	if (siglaProf == 'E') {
		form01.num_cpf.style.display='none';
		form01.num_cnpj.style.display='none';
		form01.num_cpf.value="";
		form01.num_cnpj.value="";
		if (form01.ind_insc_fiscal[0].checked==true)
			form01.num_cpf.style.display='';
		else
			form01.num_cnpj.style.display='';
	} else {
		form01.num_cpf_solicitante.style.display='none';
		form01.num_cnpj_solicitante.style.display='none';
		form01.num_cpf_solicitante.value="";
		form01.num_cnpj_solicitante.value="";
		
		form01.nome_prestador_solicitante.value = "";
		form01.sigla_conselho_solicitante.value = "";
		form01.num_crm_solicitante.value = "";
		form01.uf_conselho_solicitante.value= "";
		form01.cnes_solicitante.value = "";
		form01.cod_cbo_solicitante.value = "";
		form01.nome_cbo_solicitante.value = "";
		
		if (form01.ind_insc_fiscal_solicitante[0].checked==true)
			form01.num_cpf_solicitante.style.display='';
		else
			form01.num_cnpj_solicitante.style.display='';
	}

}
//--------------------------------

function SomaParticipacao(pIndiceItem)
{
   var qtd_informado = document.getElementById('qtd_informado_' + pIndiceItem).value;

   if (qtd_informado=="")
      return;

   var qtd_participacao = document.getElementById('qtd_participante_' + pIndiceItem);

      try{

         var sValorTotal = 0;
         var  sValorTotalCalc = 0;
         var sValorTotalCopart = 0;
         var sValorTotalApresentado = 0;
            if (qtd_participacao.value > 1 )
         {
            for (var j = 1; j <= parseInt(qtd_participacao.value); j++)
            {
               //Somar os valores apenas dos NAO marcados como exclusao
               if (document.getElementById('ind_excluir_' + pIndiceItem + '_' + j).checked!=true)
               {
                  var diff = verificaDiferenca(document.getElementById('val_calculado_' + pIndiceItem + '_' + j).value,document.getElementById('val_informado_' + pIndiceItem + '_' + j).value);
                  if ( diff == "1" ){
                     alert("O Valor Reembolsado não pode ser maior que o Valor Calculado. Função: " + document.getElementById('ind_funcao_' + pIndiceItem + '_' + j).value );
                     document.getElementById('val_informado_' + pIndiceItem + '_' + j).value = document.getElementById('val_calculado_' + pIndiceItem + '_' + j).value;
                  }
                  sValorTotal       = somaItem(sValorTotal, document.getElementById('val_informado_' + pIndiceItem + '_' + j).value);
                  sValorTotalApresentado = somaItem(sValorTotalApresentado,document.getElementById('val_apresentado_' + pIndiceItem + '_' + j).value);
               }
               sValorTotalCalc = somaItem(sValorTotalCalc, document.getElementById('val_calculado_' + pIndiceItem + '_' + j).value);
               document.getElementById('val_informado_' + pIndiceItem + '_' + j).value = document.getElementById('val_informado_' + pIndiceItem + '_' + j).value;
               document.getElementById('val_calculado_' + pIndiceItem + '_' + j).value = document.getElementById('val_calculado_' + pIndiceItem + '_' + j).value;
               document.getElementById('val_calculado_orig_' + pIndiceItem + '_' + j).value = document.getElementById('val_calculado_' + pIndiceItem + '_' + j).value;
               document.getElementById('lbl_val_calculado_' + pIndiceItem + '_' + j).innerHTML = document.getElementById('val_calculado_' + pIndiceItem + '_' + j).value;

               sValorTotalCopart = somaItem(sValorTotalCopart,document.getElementById('val_copart_' + pIndiceItem + '_' + j).value);

            }

            document.getElementById('val_reembolsado_' + pIndiceItem).value = numeroParaMoeda(sValorTotal);
            document.getElementById('val_calculado_' + pIndiceItem).value = numeroParaMoeda(sValorTotalCalc);
            document.getElementById('val_copart_' + pIndiceItem).value = numeroParaMoeda(sValorTotalCopart);
            document.getElementById('val_apresentado_' + pIndiceItem).value = numeroParaMoeda(sValorTotalApresentado);
         }else{

            document.getElementById('val_informado_' + pIndiceItem + '_1').value = document.getElementById('val_informado_' + pIndiceItem + '_1').value;
            document.getElementById('val_calculado_' + pIndiceItem + '_1').value = document.getElementById('val_calculado_' + pIndiceItem + '_1').value;
            document.getElementById('val_calculado_orig_' + pIndiceItem + '_1').value = document.getElementById('val_calculado_' + pIndiceItem + '_1').value;

            document.getElementById('val_reembolsado_' + pIndiceItem).value = document.getElementById('val_informado_' + pIndiceItem + '_1').value;
            document.getElementById('val_calculado_' + pIndiceItem).value = document.getElementById('val_calculado_' + pIndiceItem + '_1').value;
            document.getElementById('val_copart_' + pIndiceItem).value = document.getElementById('val_copart_' + pIndiceItem + '_1').value;
            document.getElementById('val_apresentado_' + pIndiceItem).value = document.getElementById('val_apresentado_' + pIndiceItem + '_1').value;
      }


   }catch(e){};
}

function numeroParaMoeda(n, c, d, t)
{
    c = isNaN(c = Math.abs(c)) ? 2 : c, d = d == undefined ? "," : d, t = t == undefined ? "." : t, s = n < 0 ? "-" : "", i = parseInt(n = Math.abs(+n || 0).toFixed(c)) + "", j = (j = i.length) > 3 ? j % 3 : 0;
    return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : "");
}

function moedaParaNumero(valor)
{
    return isNaN(valor) == false ? parseFloat(valor) :   parseFloat(valor.replace("R$","").replace(".","").replace(",","."));
}

function verificaDiferenca(pVal1, pVal2) {
    var diff;
    if (pVal1 == '') {
        pVal1 = '0';
    }
    if (pVal2 == '') {
        pVal2 = '0';
    }
    pVal1 = pVal1.replace('.', '');
    pVal1 = pVal1.replace(',', '.');

    pVal2 = pVal2.replace('.', '');
    pVal2 = pVal2.replace(',', '.');

    pVal1 = parseFloat(pVal1);
    pVal2 = parseFloat(pVal2);

    if (parseFloat(pVal2) > parseFloat(pVal1)) {
        diff = 1;
   }
    else {
        diff = 0;
    }
    return diff;
}

function somaItem(pValTotal, pValItem) {
    if (pValItem == '') {
        pValItem = '0';
    }
    return pValTotal + moedaParaNumero(pValItem);
}

function replicaValorInformado(pIndiceItem){
   if (document.getElementById('qtd_participante_' + pIndiceItem ).value=="1"){
      var diff = verificaDiferenca(document.getElementById('val_calculado_' + pIndiceItem).value,document.getElementById('val_reembolsado_' + pIndiceItem).value);
      if (document.getElementById('item_medico_' + pIndiceItem ).value!="80000037"){
         if ( diff == "1" ){
            alert("O Valor Reembolsado não pode ser maior que o Valor Calculado");
            document.getElementById('val_reembolsado_' + pIndiceItem).value = document.getElementById('val_calculado_' + pIndiceItem).value;
         }
      }
      document.getElementById('val_informado_' + pIndiceItem + '_1').value  = document.getElementById('val_reembolsado_' + pIndiceItem).value;
   }
}

function mostra_detalhe(pNomeCampo, pLinha)
{
  var sMsg = eval("document.form01." + pNomeCampo + "_" + pLinha + ".value");
  //if (sMsg!="")
  //{
      //janela = window.open('','Msg','location=no,menubar=no,directories=no,resizable=no,scrollbars=no,status=no,toolbar=no,width=400,height=300');
      try{
         if(false == janela.closed){
            janela.close ();
         }
      }catch(e){}

      janela = window.open('','Msg','location=no,menubar=no,directories=no,resizable=no,scrollbars=no,status=no,toolbar=no,width=400,height=300');
     janela.document.write('<textarea readonly cols=43 rows=16 name=txt_msg>');
      janela.document.write(sMsg);
      janela.document.write('</textarea>');
     //}
}

function mostra_detalhe_proc(pLinha)
{
  var sCodItemMedico = eval("document.form01.item_medico_" + pLinha + ".value");
  if(sCodItemMedico!=""){
    AbrePesquisaCrossBrowser('../../hes/asp/hes0008a_cons.asp?item_medico='+sCodItemMedico + '&PT=<%=txt_subtitulo%>', '', 'Consulta', 1100, 550, 50, 50, 'S');
  }
}
//------------------------------------------------------------------
function CarregaCBO() {
   if (form01.cod_cbo.value=="") {
      form01.nome_cbo.value="";
      return false;
   }
   var cp = new cpaint();
   cp.set_transfer_mode('get');
   cp.set_response_type('text');
   cp.set_debug(false);
   cp.call('../../rbm/asp/rbm0079f.asp', 'CarregaCBO', ExibeCBO, form01.cod_cbo.value);
}
//------------------------------------------------------------------
function ExibeCBO(pDescricao)
{
   document.getElementById('txt_msg').innerHTML="";
   document.getElementById('txt_msg').style.display='none';

   if (pDescricao=="-1")
   {
      document.getElementById('txt_msg').innerHTML="CBO não encontrado!";
      document.getElementById('txt_msg').style.display='';
      form01.cod_cbo.value="";
      form01.nome_cbo.value="";
   }else
      form01.nome_cbo.value=pDescricao;
}
function PesquisaExecutante(pAcao)
{
   var sChamada =  '/rbm/asp/rbm0078d.asp?PT=<%=txt_subtitulo%>';
   sChamada += '&ind_acao='+pAcao

   AbrePesquisa(sChamada, 'Pesquisa_Exec', 'Pesquisar Executante', 700, 500, 20, 15, 'S')
}
//------------------------------------------------------------------
function PesquisaSolicitante(pAcao) {
	var sChamada =  '/rbm/asp/rbm0078d.asp?PT=<%=txt_subtitulo%>';
	sChamada += '&ind_acao='+pAcao+'&ind_tipo_pesquisa=A'

	AbrePesquisaCrossBrowser(sChamada, 'Pesquisa_Exec', 'Pesquisar Solicitante', 700, 500, 20, 15, 'S')
}
//------------------------------------------------------------------
function ValidaInscricao(pCampo, tipo) {

	var checkPF = '';

	if (tipo == 'E') {
		checkPF = form01.ind_insc_fiscal[0].checked
	} else {
		checkPF = form01.ind_insc_fiscal_solicitante[0].checked
	}

	if (checkPF == true) { //PF
	
		var aux = stringReplace(pCampo.value,".","");
		aux = stringReplace(aux,"-","");

		if ((aux == "11111111111") || (aux == "22222222222") || (aux == "33333333333") ||
			(aux == "44444444444") || (aux == "55555555555") || (aux == "66666666666") ||
			(aux == "77777777777") || (aux == "88888888888") || (aux == "99999999999") ||
			( aux.length > 0 && aux.length < 11 )
			)
		{
			alert("O CPF não é válido.");
			pCampo.value = "";
			form01.nome_prestador_solicitante.value = "";
			form01.sigla_conselho_solicitante.value = "";
			form01.num_crm_solicitante.value = "";
			form01.uf_conselho_solicitante.value= "";
			form01.cnes_solicitante.value = "";
			form01.cod_cbo_solicitante.value = "";
			form01.nome_cbo_solicitante.value = "";
			return false;
		}
	
		if (!ValidaCPF(pCampo, tipo)) {
			form01.nome_prestador_solicitante.value = "";
			pCampo.value = '';					
		}
	} else {//PJ
		ValidaCNPJ(pCampo, tipo);
	}
}
//------------------------------------------------------------
function ValidaCNPJ(elm, tipo) {

	var valor = elm.value;

	if (valor == '' || isCGC(valor)) {				
		MascCgc();
		CarregaExecutante('1',tipo );
		return true;
	}
	else {
		alert("O CNPJ informado não é válido.");
		elm.value = '';
		form01.nome_prestador_solicitante.value = "";
		form01.sigla_conselho_solicitante.value = "";
		form01.num_crm_solicitante.value = "";
		form01.uf_conselho_solicitante.value= "";
		form01.cnes_solicitante.value = "";
		form01.cod_cbo_solicitante.value = "";
		form01.nome_cbo_solicitante.value = "";		
		return false;
	}
}
//------------------------------------------------------------
function ValidaCPF(elm, tipo) {

	var valor = elm.value;

	if (valor == '' || isCPF(valor)) {
		MascCpf();
		CarregaExecutante('1', tipo);
		return true;
	}
	else {
		alert("O CPF informado não é válido.");
		elm.value = '';
		return false;
	}
}
//------------------------------------------------------------
function Reexecute()
{

   document.form01.action = "<%=session("pgm_retorno")%>";
   document.form01.submit();
}

function acao_limpar(sClicado)
{
   if ( sClicado == 'N') {
      window.location = '<%=session("pgm_retorno")%>';
   }else{
      if (confirm("Deseja limpar os dados?"))
         window.location = '<%=session("pgm_retorno")%>';
   }
}
function CancelaPedido(){
   ChamaGravacao('CA');
}

function ReverteCancelamento(){
    ChamaGravacao('RC');
}

function atualizaTipoReemolso(ind_limpa){
    try{
        var qtd = form01.qtd_procedimento.value;
        for (var i = 1; i < qtd + 1; i++) {
            document.getElementById('item_medico_' + i).className = '';
            document.getElementById('item_medico_' + i).readOnly = false;
            document.getElementById('qtd_informado_' + i).className = '';
            document.getElementById('qtd_informado_' + i).readOnly = false;
            document.getElementById('Pesquisa_Item_Medido_' + i).style.display='';

            //Foi permita a edição a pedido do Clayton Volpato
            //document.getElementById('cod_especialidade_' + i).disabled = true;
            //document.getElementById('cod_especialidade_' + i).className = 'camposblocks';
        }
    }catch(e){}

    <% if ind_forma_abertura = "IN" then %>
       carregaMotivoReembolso();
    <%end if%>

    var tipo = form01.ind_tipo_reembolso.value;
	
	if (ind_limpa == 'S'){
		carregaTipoAtendimento();
	}
	
    if ( tipo == 2 )
    {
		document.form01.ind_carater_rd[0].disabled = false;
        document.form01.ind_carater_rd[1].disabled = false;
		
		if ( ind_limpa == 'S' )
        {
			document.getElementById('trAcomodacao').style.display='none';
			document.form01.ind_carater_rd[0].checked = true;			
			document.form01.ind_carater.value = document.form01.ind_carater_rd[0].value;
		}
    }
    else if ( tipo == 3 )
    {
		document.form01.ind_carater_rd[0].disabled = false;
        document.form01.ind_carater_rd[1].disabled = false;
        if ( ind_limpa == "S"){
			document.getElementById('trAcomodacao').style.display='';
            document.form01.ind_carater_rd[0].checked = true;			
            document.form01.ind_carater.value = document.form01.ind_carater_rd[0].value;
        }
    }
    else if ( tipo == 1 )
    {
		document.getElementById('trAcomodacao').style.display='none';
		document.form01.ind_carater_rd[0].disabled = true;
        document.form01.ind_carater_rd[1].disabled = true;

        <%if ( ind_acesso_cam = "S" or txt_modulo = 40 ) and ind_consulta = "S" then%>
            document.getElementById('tb_adiciona_procedimento').style.display='none';
            form01.cod_motivo_reembolso.value = "PLA";
            alteraCarater();
        <%end if%>

        if ( document.getElementById('dv_procedimento').style.display=='none' )
        {
            Expandir('dv_procedimento');
        }

        if ( ind_limpa == 'S' )
        {
			document.form01.ind_carater_rd[0].checked = true;			
            document.form01.ind_carater.value = document.form01.ind_carater_rd[0].value;
				
            try
            {
                var qtd = form01.qtd_procedimento.value;
				
                if ( qtd > 0 )
                {
                    if (confirm("Esta alteração ira limpar os procedimentos já adicionados, deseja continuar?"))
                    {
                        for( var i = 1; i <= qtd; i++ )
                        {
                            var table = document.all ? document.all['TbProcedimento'] : document.getElementById('tbParticipacao_');
                            var numRows = table.rows.length;
                            while ( numRows > 1 )
                            {
                                table.deleteRow(table.rows.length - 1);
                                numRows = table.rows.length;
                            }
                        }
                        form01.qtd_procedimento.value = "0";
                    }
                    else
                    {
                        form01.ind_tipo_reembolso.value = form01.ind_tipo_reembolso_old.value;
                        <% if ind_forma_abertura = "IN" then %>
                           carregaMotivoReembolso();
                        <%end if%>

                        var qtd = form01.qtd_procedimento.value;
                        for (var i = 1; i < qtd + 1; i++) {
                            try{
                                document.getElementById('item_medico_' + i).className = 'camposblocks';
                                document.getElementById('item_medico_' + i).readOnly = true;
                                document.getElementById('qtd_informado_' + i).className = 'camposblocks';
                                document.getElementById('qtd_informado_' + i).readOnly = true;
                                document.getElementById('Pesquisa_Item_Medido_' + i).style.display = 'none';
                                document.getElementById('cod_especialidade_' + i).disabled = false;
                                document.getElementById('cod_especialidade_' + i).className = '';
                            }catch(e){}
                        }

                        return false;
                    }
                }

                if (form01.cod_motivo_reembolso.value == "") {
                    LimpaProcedimento(pIndice);
                    return false;
                }

                form01.ind_tipo_reembolso_old.value = form01.ind_tipo_reembolso.value;

                IncluirProcedimento('S');
                document.getElementById('Pesquisa_Item_Medido_1').style.display='none';
                document.getElementById('item_medico_1').value='10101012';

                CarregaGridProcedimento(1,'I');

                if ( document.getElementById('dv_procedimento').style.display=='none' )
                {
                    Expandir('dv_procedimento');
                }
            }
            catch(e)
            {
            }
        }

        //var qtd = form01.qtd_procedimento.value;
        //for (var i = 1; i < qtd + 1; i++) {
        //    try{
        //        document.getElementById('item_medico_' + i).className = 'camposblocks';
        //        document.getElementById('item_medico_' + i).readOnly = true;
        //        document.getElementById('qtd_informado_' + i).className = 'camposblocks';
        //        document.getElementById('qtd_informado_' + i).readOnly = true;
        //        document.getElementById('Pesquisa_Item_Medido_' + i).style.display='';
        //        document.getElementById('cod_especialidade_' + i).disabled = false;
        //    }catch(e){}
        //}
    }

   //atualizaPrazo();
}
//------------------------------------------------------------------
function alteraCarater(){

    var tipo = form01.ind_tipo_reembolso.value;
    var motivoReembolso = form01.ind_tipo_reembolso.value;
    var qtd = form01.qtd_procedimento.value;

    if(form01.cod_motivo_reembolso.value != "" && tipo == "1" && qtd <= 0){
        form01.ind_tipo_reembolso_old.value = form01.ind_tipo_reembolso.value;

        IncluirProcedimento('S');
        document.getElementById('Pesquisa_Item_Medido_1').style.display='none';
        document.getElementById('item_medico_1').value='10101012';

        CarregaGridProcedimento(1,'I');

        if ( document.getElementById('dv_procedimento').style.display=='none' )
        {
            Expandir('dv_procedimento');
        }
    }

   var cod_motivo = document.form01.cod_motivo_reembolso.value;
   if ( cod_motivo != "" ){
      document.getElementById('trCarater').style.display='';
      if ( cod_motivo == 'URG' ) {
         document.form01.ind_carater_rd[1].checked = true;
         document.form01.ind_carater.value = document.form01.ind_carater_rd[1].value;
      }else{
         document.form01.ind_carater_rd[0].checked = true;
         document.form01.ind_carater.value = document.form01.ind_carater_rd[0].value;
      }
   }else{
      document.form01.ind_carater_rd[0].checked = true;
      document.form01.ind_carater.value = document.form01.ind_carater_rd[0].value;
   }
}
//------------------------------------------------------------------
function validaMotivo(){
   var cod_motivo = document.form01.cod_motivo_reembolso.value;
   var ind_reembolso = document.form01.ind_plano_com_reembolso.value;
   if ( cod_motivo != "" ){
       if ( cod_motivo == 'PLA' && ind_reembolso == "N" ) {
         alert("Não é possível selecionar esta opção, o plano do beneficiário não permite reembolso.");
         form01.cod_motivo_reembolso.value = form01.cod_motivo_reembolso_old.value;
         return false;
      }
   }
   form01.cod_motivo_reembolso_old.value = form01.cod_motivo_reembolso.value;
   return true;
}
//------------------------------------------------------------------
function carregaMotivoReembolso() {
   if (form01.ind_tipo_reembolso.value=="") {
      return false;
   }
   var cp = new cpaint();
   cp.set_transfer_mode('get');
   cp.set_response_type('text');
   cp.set_debug(false);
   cp.call('../../rbm/asp/rbm0079f.asp', 'CarregaMotivoReembolso', ExibeMotivoReembolso, form01.ind_tipo_reembolso.value, "alteraCarater();validaMotivo();");
}
//------------------------------------------------------------------
function ExibeMotivoReembolso(pDescricao)
{

   if (pDescricao=="-1")
   {
      document.getElementById('txt_msg').innerHTML="Ocorreu um erro ao carregar ao carregar os motivos de reembolso!";
      document.getElementById('txt_msg').style.display='';
   }else
      document.getElementById('tdMotivoReembolso').innerHTML=pDescricao;


   <%if ( ind_acesso_cam = "S" or txt_modulo = 40 ) and ind_consulta = "S" then%>
      form01.cod_motivo_reembolso.value = "PLA";
      form01.cod_motivo_reembolso_old.value = "PLA";
   <%end if%>

}
//------------------------------------------------------------------
function MontaComboEspecialidade(iLinha) {

    var cp = new cpaint();
    cp.set_transfer_mode('get');
    cp.set_debug(false);
    cp.call('../../rbm/asp/rbm0079f.asp', 'CarregaEspecialidade', ExibeEspecialidade, iLinha);
}
//------------------------------------------------------------------
function ExibeEspecialidade(pXML)
{
    var tabela = pXML.ajaxResponse[0].find_item_by_id('result', 'tabela');
    document.getElementById('dvEspecialidade_' + tabela.indice[0].data).innerHTML = tabela.combo[0].data;
}
//------------------------------------------------------------------
function VerificaPrincipal(pLinha)
{
   var ind_principal = document.getElementById('ind_principal_' + pLinha).value;
   var ind_cirurgia  = document.getElementById('ind_cirurgia_' + pLinha).value;
   var grupo  = document.getElementById('cod_grupo_estatistico_' + pLinha).value;
   var principalAnt  = "";

   if (ind_cirurgia!="S" && ind_principal=="S")
   {
       document.getElementById('ind_principal_' + pLinha).value = "N";
       alert("Procedimento não pode ser principal, pois não trata-se de um procedimento cirurgico");
       return false;
   }

   MostrarWait();


   if (ind_principal=="S")
   {

      //Desmarcar demais itens e caso estivesse como prinipal, recalcular
      var qtd_procedimento = form01.qtd_procedimento.value;
      for (var k = 1; k <= parseInt(form01.qtd_procedimento.value); k++)
      {
         if (pLinha != k){
            if ( document.getElementById('ind_principal_' + k).value == "S" ){
               principalAnt = k;
            }
            document.getElementById('ind_principal_' + k).value="N";
         }

         //RECALCULAR ITEM
         MontaComboPrincipal(k);
      }


   }else{
      //Calcular valor deste item
      MontaComboPrincipal(pLinha);
   }

   MontaComboDoppler(pLinha, grupo)

   if ( principalAnt != "" ){
      CarregaGridProcedimento(principalAnt,'A');
   }


   CarregaGridProcedimento(pLinha,'A');


   document.getElementById('waitbar').style.display = 'none';

}

function MontaComboPrincipal(pIndice)
{
   try{

      var ind_via = document.getElementById('ind_via_' + pIndice).value;
      var ind_principal = document.getElementById('ind_principal_' + pIndice).value;
      var ind_cirurgia = document.getElementById('ind_cirurgia_' + pIndice).value;
      var sTxtCombo = '';
      var sSelected = '';

      sTxtCombo = "<select id='ind_via_" + pIndice + "' name='ind_via_" + pIndice + "' tabindex='1' onchange='VerificaPrincipal(" + pIndice + ");'>";
      sTxtCombo += "<option value=''></option>";
      if (ind_cirurgia=="S" && ind_principal!="S")
      {
         if (ind_via == "M") sSelected = " selected "; else sSelected = "";
         sTxtCombo += "<option value='M' " + sSelected + ">Mesma Via</option>";

         if (ind_via == "D") sSelected = " selected "; else sSelected = "";
         sTxtCombo += "<option value='D'" + sSelected + ">Diferentes Vias</option>";
      } else {
         if (ind_via == "U" || ind_principal=="S") sSelected = " selected "; else sSelected = "";
         sTxtCombo += "<option value='U'" + sSelected + ">Via Única</option>";
      }
      sTxtCombo += "</select>";

   }catch(e){

      sTxtCombo = "<select id='ind_via_" + pIndice + "' name='ind_via_" + pIndice + "' tabindex='1'></select>";
   }

   document.getElementById('dvVia_' + pIndice).innerHTML = sTxtCombo;
}

function MontaComboDoppler(pIndice, grupo)
{

   try{

      var ind_doppler = document.getElementById('ind_doppler_' + pIndice).value;
      var sTxtCombo = '';
      var sSelected = '';

      sTxtCombo = "<select id='ind_doppler_" + pIndice + "' name='ind_doppler_" + pIndice + "' tabindex='1' onchange='VerificaPrincipal(" + pIndice + ");'>";
      sTxtCombo += "<option value=''></option>";
      if ( grupo == "USE" ){
         if (ind_doppler == "P") sSelected = " selected "; else sSelected = "";
         sTxtCombo += "<option value='P' " + sSelected + ">Pulsado e Continuo</option>";

         if (ind_doppler == "C") sSelected = " selected "; else sSelected = "";
         sTxtCombo += "<option value='C'" + sSelected + ">Colorido</option>";
      }
      sTxtCombo += "</select>";

   }catch(e){

      sTxtCombo = "<select id='ind_doppler_" + pIndice + "' name='ind_doppler_" + pIndice + "' tabindex='1'></select>";
   }

   document.getElementById('dvDoppler_' + pIndice).innerHTML = sTxtCombo;
}


function trataStr(param){
   str = param.replace( /"/g , "&quot;" ).replace( /'/g , "&#39;" );
   return str;
}

function ExecutarAcao(IndOpcao) {
   if (form01.ind_executando.value=="S") {
      alert("Execução em andamento, aguarde....");
      return false;
   }

   var txt_obs_emissao   = new String(document.form01.txt_observacao.value).replace('"',"");
   var txt_obs_operadora = new String(document.form01.txt_observacao_operadora.value).replace('"',"");

   var sAction;
   var vHeigth;

   switch (IndOpcao) {
      case "FN"://FINALIZAR
         vHeigth = "450";
         sAction = '../../rbm/asp/rbm0078e.asp?PT=<%=txt_subtitulo%>&ind_acao=A&data_solicitacao=' + document.form01.dt_solicitacao.value + '&num_reembolso=' + form01.num_reembolso.value+ '&txt_email=' + form01.txt_email.value;
         break;
      case "CA"://CANCELAR
         vHeigth = "510";
         sAction = '../../rbm/asp/rbm0078f.asp?PT=<%=txt_subtitulo%>&ind_acao=A&data_solicitacao=' + document.form01.dt_solicitacao.value + '&num_reembolso=' + form01.num_reembolso.value;
         break;
      case "TR"://TRANSFERIR GRUPO ANÁLISE
         vHeigth = "510";
         sAction = '../../rbm/asp/rbm0078g.asp?PT=<%=txt_subtitulo%>&ind_acao=A&data_solicitacao=' + document.form01.dt_solicitacao.value + '&num_reembolso=' + form01.num_reembolso.value;
         break;
   }
   AbrePesquisa(sAction,'','Alteração',630,vHeigth,50,50,'S');
}

//------------------------------------------------------------------
//pTipo:
//1 - CPF/CNPJ
//2 - CRM
function CarregaExecutante(pTipo, tipoFunc) {

	var sCheckPF = '';
	var sCampoValueCPF = '';
	var sCampoValueCNPJ = '';
	var sCampoValueCRM = '';
	var sCampoValueSiglaConselho = '';
	var sCampoValueUfConselho = '';

	form01.tipo_crm_cnpj.value =pTipo;
	
	if (tipoFunc == 'E') {
		tipoFuncao = 'E';
		sCheckPF = form01.ind_insc_fiscal[0].checked;
		sCampoValueCPF = form01.num_cpf.value;
		sCampoValueCNPJ = form01.num_cnpj.value;
		sCampoValueCRM = form01.num_crm.value;
		sCampoValueSiglaConselho = form01.sigla_conselho.value;
		sCampoValueUfConselho = form01.uf_conselho.value;
	} else {
		tipoFuncao = 'S';
		sCheckPF = form01.ind_insc_fiscal_solicitante[0].checked;
		sCampoValueCPF = form01.num_cpf_solicitante.value;
		sCampoValueCNPJ = form01.num_cnpj_solicitante.value;
		
		if (pTipo!="1") {
			sCampoValueCRM = form01.num_crm_solicitante.value;
			sCampoValueSiglaConselho = form01.sigla_conselho_solicitante.value;
			sCampoValueUfConselho = form01.uf_conselho_solicitante.value;
		}
		
	}

	if (pTipo=="1") {
		if (sCheckPF) {
			if (sCampoValueCPF=="")
				return false;
		}else{
			if (sCampoValueCNPJ=="")
				return false;
		}

	}else{
		if (sCampoValueCRM=="")
			return false;
	}

	var sXMLFiltro = '<SOLICITANTE>';
	var sNumInscricao = '';
	if (sCheckPF) {
		sXMLFiltro += '<IND_TIPO_PESSOA>F</IND_TIPO_PESSOA>'
		sNumInscricao = sCampoValueCPF;
	}else{
		sXMLFiltro += '<IND_TIPO_PESSOA>J</IND_TIPO_PESSOA>'
		sNumInscricao = sCampoValueCNPJ;
	}

	sXMLFiltro += '<NUM_INSC_FISCAL>' + sNumInscricao + '</NUM_INSC_FISCAL>'

	if (sCampoValueCRM!="") {
		sXMLFiltro += '<SIGLA_CONSELHO>' + sCampoValueSiglaConselho + '</SIGLA_CONSELHO>'
		sXMLFiltro += '<NUM_CRM>' + sCampoValueCRM + '</NUM_CRM>'
		sXMLFiltro += '<SGL_UF_CONSELHO>' + sCampoValueUfConselho + '</SGL_UF_CONSELHO>'
	}
	sXMLFiltro += '</SOLICITANTE>';

	var cp = new cpaint();
	cp.set_transfer_mode('get');
	cp.set_debug(false);
	cp.set_response_type('text');
	cp.call('../../rbm/asp/rbm0079f.asp', 'CarregaExecutante', ExibeExecutante, sXMLFiltro);
}
//------------------------------------------------------------------
function ExibeExecutante(pXML) {
   var xmlDoc            = null;
   var xml_no            = null;

   document.getElementById('txt_msg').innerHTML     = '';
   document.getElementById('txt_msg').style.display = 'none';

	//ABRIR O XML
	try{
		xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
		xmlDoc.async = false;
		xmlDoc.loadXML(pXML);
	
		xml_no = xmlDoc.getElementsByTagName("DADOS");
	
		if (xml_no.length=="0") {
			document.getElementById('txt_msg').innerHTML = 'Solicitante não encontrado';
			document.getElementById('txt_msg').style.display = '';
			
			if (form01.tipo_crm_cnpj.value == "1") {
				form01.nome_prestador_solicitante.value = "";	
				form01.sigla_conselho_solicitante.value = "";
				form01.num_crm_solicitante.value = "";
				form01.uf_conselho_solicitante.value= "";
				form01.cnes_solicitante.value = "";
				form01.cod_cbo_solicitante.value = "";
				form01.nome_cbo_solicitante.value = "";
			}			    					
			
		
			return false;
		}

		if (xml_no.length>1) {
			if (tipoFuncao == 'E') {
				PesquisaExecutante('S');
			} else {
				PesquisaSolicitante('T')
			}
			return false;
		}
	
		for(var x=0; x < xml_no.length; x++) {
			if (xml_no[x].getElementsByTagName("COD_RETORNO")[0].text=="9") {
				document.getElementById('txt_msg').innerHTML = xml_no[x].getElementsByTagName("MSG_RETORNO")[0].text;
				document.getElementById('txt_msg').style.display = '';
				return false;
			}else{ 

				if (tipoFuncao == 'E') {
					form01.num_cpf.value = "";
					form01.num_cnpj.value= "";

					form01.nome_prestador.value = xml_no[x].getElementsByTagName("NOME_SOLICITANTE")[0].text;
				
					if (form01.ind_insc_fiscal[0].checked){
						form01.num_cpf.value = xml_no[x].getElementsByTagName("NUM_CPF")[0].text;
					}
					else{
						form01.num_cnpj.value = xml_no[x].getElementsByTagName("NUM_CNPJ")[0].text; 
					}
						
					form01.sigla_conselho.value = xml_no[x].getElementsByTagName("SIGLA_CONSELHO")[0].text;
					form01.num_crm.value = xml_no[x].getElementsByTagName("NUM_CRM")[0].text;
					form01.uf_conselho.value = xml_no[x].getElementsByTagName("SGL_UF_CONSELHO")[0].text;
					form01.cod_municipio_execucao.value = xml_no[x].getElementsByTagName("COD_MUNICIPIO_EXECUCAO")[0].text;
					form01.nom_municipio_execucao.value = xml_no[x].getElementsByTagName("NOME_MUNICIPIO_EXECUCAO")[0].text;
				} else {
					form01.num_cpf_solicitante.value = "";
					form01.num_cnpj_solicitante.value= "";

					form01.nome_prestador_solicitante.value = xml_no[x].getElementsByTagName("NOME_SOLICITANTE")[0].text;
				
					if (form01.ind_insc_fiscal_solicitante[0].checked){
						form01.num_cpf_solicitante.value = xml_no[x].getElementsByTagName("NUM_CPF")[0].text;
					}
					else{
						form01.num_cnpj_solicitante.value = xml_no[x].getElementsByTagName("NUM_CNPJ")[0].text; 
					}
						
					form01.sigla_conselho_solicitante.value = xml_no[x].getElementsByTagName("SIGLA_CONSELHO")[0].text;
					form01.num_crm_solicitante.value = xml_no[x].getElementsByTagName("NUM_CRM")[0].text;
					form01.uf_conselho_solicitante.value = xml_no[x].getElementsByTagName("SGL_UF_CONSELHO")[0].text;
				}
			}
		}
		xmlDoc = null
		xml_no = null
	
	}catch(e){
		document.getElementById('txt_msg').innerHTML     = 'Ocorreu um erro ao recuperar o Executante: ' + e.message;
		document.getElementById('txt_msg').style.display = '';
		return false;
	}
}
//------------------------------------------------------------------
function atualizaDadosTipoAtendimento(pIndAltera){	
    var cod_tratamento = form01.cod_tratamento.value;
	
    var cod_motivo = form01.cod_motivo_reembolso.value;

	var qtd_procedimento = form01.qtd_procedimento.value;
	
	if (pIndAltera != "N") {
		switch(cod_tratamento){
	
			case '5':
				if ( cod_motivo != "TRA" ){
					document.form01.ind_carater_rd[0].disabled = true;
					document.form01.ind_carater_rd[1].disabled = true;
					document.form01.ind_carater_rd[0].checked = true;			
					document.form01.ind_carater.value = document.form01.ind_carater_rd[0].value;
				}
				
				if (qtd_procedimento != 1) {
					for( var i = 1; i <= qtd_procedimento; i++ ){
						
						var table = document.all ? document.all['TbProcedimento'] : document.getElementById('tbParticipacao_');
						var numRows = table.rows.length;				
						while ( numRows > 1 ) {
							table.deleteRow(table.rows.length - 1);					
							numRows = table.rows.length;
						}
					}

					form01.qtd_procedimento.value = 0;
					form01.num_item_atual.value = 1;
					form01.val_informado.value="";
					form01.dt_atendimento_proc.value= "";
					form01.hr_atendimento_inicio.value="";
					form01.hr_atendimento_fim.value="";
					form01.cod_procedimento_principal.value="";
					form01.nome_procedimento_principal.value="";                    
					IncluirProcedimento('S');
					
					form01.item_medico.value = '10101012';
					form01.qtd_informado.value = 1;
					form01.cod_funcao.value=12;
					AtualizaLinhaProcedimento();
					
					CarregaGridProcedimento();
				}
				break;
			case '45':
				if ( cod_motivo != "TRA" ){
					document.form01.ind_carater_rd[0].disabled = true;
					document.form01.ind_carater_rd[1].disabled = true;
					document.form01.ind_carater_rd[1].checked = true;			
					document.form01.ind_carater.value = document.form01.ind_carater_rd[1].value;
				}
				
				for( var i = 1; i <= qtd_procedimento; i++ ){
					
					var table = document.all ? document.all['TbProcedimento'] : document.getElementById('tbParticipacao_');
					var numRows = table.rows.length;				
					while ( numRows > 1 ) {
						table.deleteRow(table.rows.length - 1);					
						numRows = table.rows.length;
					}
				}

				form01.qtd_procedimento.value = 0;
				form01.num_item_atual.value = 1;
				form01.val_informado.value="";
				form01.dt_atendimento_proc.value= "";
				form01.hr_atendimento_inicio.value="";
				form01.hr_atendimento_fim.value="";
				form01.cod_procedimento_principal.value="";
				form01.nome_procedimento_principal.value="";                    
				IncluirProcedimento('S');
				
				form01.item_medico.value = "";
				form01.nome_item_proc.value = "";
				form01.qtd_informado.value = "";
				form01.cod_funcao.value="";
				AtualizaLinhaProcedimento();
				
				CarregaGridProcedimento();
				
				break;
			case '37':
				//exibe motivo alta 
				document.getElementById('trAcomodacao').style.display='none';
				document.form01.cod_acomodacao.options[0].selected = true;
				//document.getElementById('trCarater').style.display='none';
				//document.getElementById('trObito').style.display='none';
				break;
		
			case '1':
			case '6':
			case '10':
			case '27':
			case '41':
			case '42':
			case '31':
			case '32':
			case '39':
			case '29':
			case '30':
				//exibe acomodacao / motivo alta	
				document.getElementById('trAcomodacao').style.display='';

				//document.getElementById('trCarater').style.display='none';
				//document.getElementById('trObito').style.display='none';
				break;
		
			case '2':
			case '17':
			case '33':
			case '34':
			case '35':
			case '36':
				// exibe carater / motivo alta / cid obito / declaracao obito
				document.getElementById('trAcomodacao').style.display='none';
				document.form01.cod_acomodacao.options[0].selected = true;
				//document.getElementById('trCarater').style.display='';
				//document.getElementById('trObito').style.display='';		
				break;
		
			case '7':
			case '8':
			case '9':
			case '26':
			case '28':
			case '38':
			case '40':
				// exibe carater / acomodacao / motivo alta / cid obito / declaracao obito	
				document.getElementById('trAcomodacao').style.display='';
				//document.getElementById('trCarater').style.display='';
				//document.getElementById('trObito').style.display='';		
				break;
					
			default:

				if ( cod_motivo != "TRA" ){
					
					document.getElementById('trAcomodacao').style.display='none';
					document.form01.cod_acomodacao.options[0].selected = true;

					//document.getElementById('trCarater').style.display='none';
					//document.getElementById('trObito').style.display='none';
					document.form01.ind_carater_rd[0].disabled = false;
					document.form01.ind_carater_rd[1].disabled = false;
					document.form01.ind_carater_rd[0].checked = true;			
					document.form01.ind_carater.value = document.form01.ind_carater_rd[0].value;
				}
				
				break;
		}
	}
}
//------------------------------------------------------------------
function alteraCarater(){
    var cod_motivo = document.form01.cod_motivo_reembolso.value;
    if ( cod_motivo != "" ){
        //document.getElementById('trCarater').style.display='';
        if ( cod_motivo == 'URG' ) {
            document.form01.ind_carater_rd[1].checked = true;			
            document.form01.ind_carater.value = document.form01.ind_carater_rd[1].value;
        }else{
            document.form01.ind_carater_rd[0].checked = true;			
            document.form01.ind_carater.value = document.form01.ind_carater_rd[0].value;
        }		
    }
}
//------------------------------------------------------------------
function gravaCarater(){
    if ( document.form01.ind_carater_rd[1].checked  == true ){
        document.form01.ind_carater.value = document.form01.ind_carater_rd[1].value;
    }else if ( document.form01.ind_carater_rd[0].checked  == true ){
        document.form01.ind_carater.value = document.form01.ind_carater_rd[0].value;
    }
}
//-------------------------------------------------------------------------------------------
function AbreGlosa(pNumLinha, pIndAlteracao) {
    var ind_situacao            = "";
    var num_seq_item            = "";

    if (pNumLinha!="0") {
        try{num_seq_item          = eval("document.form01.num_seq_item_" + pNumLinha + ".value")}catch(e){};
    }
    var sChamada = '/rbm/ASP/RBM1012f.asp';
    sChamada = sChamada + '?num_reembolso='         + form01.num_reembolso_ant.value;
    sChamada = sChamada + '&num_seq_item='          + num_seq_item;
    sChamada = sChamada + '&num_linha='             + pNumLinha;
    sChamada = sChamada + '&ind_alteracao='         + pIndAlteracao;
    AbrePesquisa(sChamada,'Glosa Prévia Reembolso','Glosa Prévia Reembolso', 1200, 300, 5, 5, 'S');
}

function redireciona_impressao(pNumReembolso, msg){

   var txt_email    = document.form01.txt_email.value;
   var txt_ddd_fax  = document.form01.txt_ddd_fax.value;
   var txt_num_fax  = document.form01.txt_num_fax.value;
   //var txt_ramal_fax  = document.form01.txt_ramal_fax.value;
   var tipo_finalizacao = document.form01.ind_tipo_finalizacao.value;
   var ind_retorno_fila = "N";
    <%

   if instr(pgm,"rbm1007")>0 then
      ind_retorno_fila = "S"
   else
      ind_retorno_fila = "N"
    end if
   %>

    if (tipo_finalizacao == "R") {

         window.location = 'rbm0078j.asp?ind_origem=AL&ind_tipo_emissao='+ tipo_emissao+'&num_protocolo='+ document.form01.num_reembolso.value+'&num_reembolso_ant='+ pNumReembolso+'&txt_email='+txt_email+'&tipo_finalizacao='+tipo_finalizacao+'&pgm=<%=pgm%>'+'&pt=<%=txt_subtitulo%>';

    } else{
    if(form01.ind_tipo_emissao[0].checked){
        // Email
        var tipo_emissao = "E"
        txt_impressao = "\nDeseja enviar por e-mail?"
    }else if(form01.ind_tipo_emissao[1].checked){
        //fax
        var tipo_emissao = "F"
        txt_impressao = "\nDeseja enviar por fax?"
        }else{
        //imprssao
        var tipo_emissao = "I"
        txt_impressao = "\nDeseja imprimir?"
        }

    if (!confirm(msg + txt_impressao )){
        <% if ind_retorno_fila = "S" then %>
        window.location = '../../rbm/asp/<%=pgm%>?<%=session("retorno_pgm_sit")%>'
        return;
        <%else%>
        window.location = '<%=txt_pgm_retorno%>'
        return;
        <%end if%>
    }

    if(tipo_emissao == "E"){
           window.location = 'RBM1008b.asp?ind_origem=AL&ind_tipo_emissao='+ tipo_emissao+'&num_reembolso_ant='+ pNumReembolso+'&txt_email='+txt_email+'&tipo_finalizacao='+tipo_finalizacao+'&pgm=<%=pgm%>'+'&pt=<%=txt_subtitulo%>';
    }else if(tipo_emissao == "F"){
            window.location = 'RBM1008b.asp?ind_origem=AL&ind_tipo_emissao='+ tipo_emissao+'&num_reembolso_ant='+ pNumReembolso+'&txt_ddd_fax='+txt_ddd_fax+'&txt_num_fax='+txt_num_fax+'&pgm=<%=pgm%>'+'&pt=<%=txt_subtitulo%>';
    }else{  //impressão
            window.location = 'RBM1008b.asp?ind_origem=AL&ind_tipo_emissao='+ tipo_emissao+'&num_reembolso_ant='+ pNumReembolso+'&tipo_finalizacao='+tipo_finalizacao+'&pgm=<%=pgm%>'+'&pt=<%=txt_subtitulo%>';
        }
    }

}


<% if num_reembolso <> "" then %>
   atualizaTipoReemolso('N');
	atualizaDadosTipoAtendimento('N');
   if ( document.form01.qtd_procedimento.value > 0 ) {
      Expandir('dv_procedimento');
   }

    verificaOcorrencia();
   alteraCarater()
<% end if %>


<% if num_associado <> "" and ( ind_acesso_cam = "S" or txt_modulo = 40 ) then %>
   CarregaDadosAssociado();

   <%if ind_consulta = "S" then%>
      if( form01.ind_plano_com_reembolso.value != 'S' ){
         alert("Beneficiário sem direito a reembolso. Cadastro não permitido.");
          try {

              window.parent.dialogWindow.close();

          }

          catch (e) {


              parent.self.close();

          }
      }

      form01.ind_tipo_reembolso.value = 1;
      atualizaTipoReemolso();
      atualizaPrazo(form01.cod_inspetoria_ts_abertura.value);
      try{form01.ind_tipo_reembolso.focus();}catch(e){};
   <%end if%>

<% end if %>

    //-------------------------------------------------------------------------------------------
	function AlteraIcone(i) {
		var imgElement = document.getElementById("clips_" + i);
		if (imgElement) {
			imgElement.src = "\\gen\\img\\clips_1_pb.gif";
			  
		}		  
	}

function acao_voltar(){
    try {
        window.parent.dialogWindow.close();
    }
    catch (e) {
        window.close();
       parent.self.close();
    }
}

//-------------------------------------------------------------------------------------------
function AbreMemoriaDeCalculo(i){
   var num_seq_item;
   var num_reembolso;
   var linha;

   try{
      num_reembolso = form01.num_reembolso.value;
   }catch(e){
      num_reembolso = 0;
   }

   try{
      num_seq_item = eval("document.form01.num_seq_item_" + i + ".value");
   }catch(e){
      try{
         num_seq_item = eval("document.form01.num_seq_item_" + i + "_1.value");
      }catch(e){
         num_seq_item = 0;
      }
   }

   linha = i;


   var sChamada = '/RBM/ASP/RBM0078l.asp';
      sChamada    += '?num_reembolso=' + num_reembolso;
      sChamada    += '&num_seq_item=' + num_seq_item;
      sChamada    += '&linha_item=' + linha;


   AbrePesquisaCrossBrowser(sChamada,'Memoria_de_Calculo','Memória de Cálculo', 1000, 550, 5, 5, 'S');

}
//-------------------------------------------------------------------------------------------
function ReexecutaSituacao() {
   document.form01.action = '../../rbm/asp/<%=pgm & "?" & session("retorno_pgm_sit")%>';
   document.form01.submit();

}
//-----------------------------
function loadXMLString(txt) {

   var xmlDoc;
   var parser;

   if (window.DOMParser) {

      parser=new DOMParser();


      xmlDoc=parser.parseFromString(txt,"text/xml");
   } else // Internet Explorer
   {
      xmlDoc=new ActiveXObject("Microsoft.XMLDOM");
      xmlDoc.async=false;
      xmlDoc.loadXML(txt);
   }
   return xmlDoc;
}
//------------------------------------------------------------------
function carregaTipoAtendimento() {

    if (form01.ind_tipo_reembolso.value=="") {
        return false;
    }
    var cp = new cpaint();
    cp.set_transfer_mode('get');
    cp.set_response_type('text');
    cp.set_debug(false);
    cp.call('../../rbm/asp/rbm0079f.asp', 'CarregaTipoAtendimento', ExibeTipoAtendimento, form01.ind_tipo_reembolso.value); 
}
//------------------------------------------------------------------
function ExibeTipoAtendimento(pDescricao) {

    if (pDescricao=="-1") {
        document.getElementById('txt_msg').innerHTML="Ocorreu um erro ao carregar ao carregar os motivos de alta!";
        document.getElementById('txt_msg').style.display='';
    }else
        document.getElementById('tdTipoAtendimento').innerHTML=pDescricao;
}
//------------------------------------------------------------------
function atualizaIndAcomodacao() {

    if (form01.cod_acomodacao.value=="") {
        return false;
    }
    var cp = new cpaint();
    cp.set_transfer_mode('get');
    cp.set_response_type('text');
    cp.set_debug(false);
    cp.call('../../rbm/asp/rbm0079f.asp', 'CarregaTipoAcomodacao', ExibeIndAcomodacao, form01.cod_acomodacao.value); 
}
//------------------------------------------------------------------
function ExibeIndAcomodacao(pDescricao) {
    if (pDescricao=="-1") 	{
        form01.ind_acomodacao.value  = "";
    }else{
        form01.ind_acomodacao.value=pDescricao;
    }

}
//------------------------------------------------------------------
</script>

<%
'-----------------------------------------------------------
' Recuperar o parametro informado da tabela controle_sistema
'-----------------------------------------------------------
Function RetornaParametro(pCodParametro, pValDefault)
   Dim vetParam(3, 4)

   vetParam(1, 1) = "IN"
   vetParam(1, 2) = "adVarChar"
   vetParam(1, 3) = "p_cod_parametro"
   vetParam(1, 4) = pCodParametro

   vetParam(2, 1) = "OUT"
   vetParam(2, 2) = "adVarChar"
   vetParam(2, 3) = "p_val_parametro"

   vetParam(3, 1) = "IN"
   vetParam(3, 2) = "adVarChar"
   vetParam(3, 3) = "p_val_default"
   vetParam(3, 4) = pValDefault

   Call ExecutaPLOracle (   CStr(session("ace_usuario")),_
                       CStr(session("ace_senha")),_
                     CStr(session("ace_ip")),_
                     CStr(session("ace_sistema")),_
                     CStr(session("ace_modulo")),_
                     "RB_PREVIA_REEMBOLSO.RetornaParametro", _
                     vetParam, _
                     false )

   RetornaParametro = vetParam(2, 4)

end function
%>