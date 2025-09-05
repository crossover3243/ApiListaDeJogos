<%@ LANGUAGE="VBSCRIPT" %>
<!--#include file="..\..\gen\js\cpaint2.inc.asp"-->
<!--#include file=..\..\gen\asp\gen0146a.asp-->
<!--#include file=..\..\gen\asp\gen0146b.asp-->
<%
	set cp = new cpaint

	cp.register("CarregaPrestador")
	cp.register("VerificaNR")
	cp.register("RecuperaComboConta")
	cp.register("RecuperaAnexosConta")
	cp.start("ISO-8859-1")
	cp.return_data

	function CarregaPrestador(pCodPrestador)

		Dim sNomePrestador, sCodPrestadorTS, rsPesquisa
		Dim vetParam(5, 4)

		vetParam(1, 1) = "IN"
		vetParam(1, 2) = "adVarChar"
		vetParam(1, 3) = "p_nome_tabela"
		vetParam(1, 4) = "prestador_servico"

		vetParam(2, 1) = "IN"
		vetParam(2, 2) = "adVarChar"
		vetParam(2, 3) = "p_campo_value"
		vetParam(2, 4) = "cod_prestador_ts"

		vetParam(3, 1) = "IN"
		vetParam(3, 2) = "adVarChar"
		vetParam(3, 3) = "p_campo_desc"
		vetParam(3, 4) = "nome_prestador"

		vetParam(4, 1) = "IN"
		vetParam(4, 2) = "adVarChar"
		vetParam(4, 3) = "p_order"
		vetParam(4, 4) = ""

		vetParam(5, 1) = "IN"
		vetParam(5, 2) = "adVarChar"
		vetParam(5, 3) = "p_where"
		vetParam(5, 4) = "where cod_prestador = '" & pCodPrestador & "'"

		Set rsPesquisa = rsCursorOracle(CStr(session("ace_usuario")),_
										CStr(session("ace_senha")),_
										CStr(session("ace_ip")),_
										CStr(session("ace_sistema")),_
										CStr(session("ace_modulo")),_
										"AUT_RCS_CONSULTA_PEDIDO.get_cursor", _
										vetParam, _
										false )

		set tabela = cp.add_node("resultado", "tabela")
		set registro = tabela.add_node ("eof", 1)
		
		if not rsPesquisa.EOF then
			registro.set_data "N"
			set registro = nothing
			
			set registro = tabela.add_node ("codPrestadorTs", 1)
			registro.set_data rsPesquisa("cod_prestador_ts") & ""
			set registro = nothing
			
			set registro = tabela.add_node ("nomePrestador", 1)
			registro.set_data rsPesquisa("nome_prestador") & ""
			set registro = nothing
		else
			registro.set_data "S"
			set registro = nothing
		end if
		
		rsPesquisa.Close
		Set rsPesquisa = nothing	
		CarregaPrestador = vbnull
		set tabela = nothing

	end function

	function VerificaNR(p_cod_prestador_ts, p_mes_ano_ref, p_nome_funcao)
		dim rsPesquisa
		dim tabela, registro
		dim strCombo, s_xml
		dim vet_PL(2,4)

		'monta xml parâmetros
		s_xml = "<?xml version=""1.0"" encoding=""ISO-8859-1""?>" & _
				"<parametro>" & _
				"<pMesAnoRef>01/" & p_mes_ano_ref & "</pMesAnoRef>"  & _
				"<pCodPrestadorTs>" & p_cod_prestador_ts & "</pCodPrestadorTs>"  & _
				"</parametro>"
			
		'Pesquisa de NR
		vet_PL(1, 1) = "IN"
		vet_PL(1, 2) = "adLongVarChar"
		vet_PL(1, 3) = "p_xml_parametros"
		vet_PL(1, 4) = s_xml
				
		vet_PL(2, 1) = "IN"
		vet_PL(2, 2) = "adVarChar"
		vet_PL(2, 3) = "p_ctr_logs"
		vet_PL(2, 4) = "S"

		set rsPesquisa = rsCursorOracle(CStr(Session("ace_usuario")),_
										CStr(Session("ace_senha")),_
										CStr(Session("ace_ip")),_
										CStr(Session("ace_sistema")),_
										CStr(Session("ace_modulo")),_
										"ctm_rcs_telas_relatorios.get_ctm_nr_grd", _		
										vet_PL, _
										false )

		strCombo = "<select name='p_cod_nr' id='p_cod_nr' onChange='recuperaContas();' style='display:'>"

		if not rsPesquisa.eof then
			strCombo = strCombo & "<option value=''></option> "
			do while not rsPesquisa.eof
				strCombo = strCombo & "<option value='" & rsPesquisa("num_grd") & "' >" & rsPesquisa("num_grd") & "</option>"
				rsPesquisa.MoveNext
			loop
		else
			rsPesquisa.close
			set rsPesquisa = nothing
		end if
			
		strCombo = strCombo & "</select>"
	
		cp.set_id "response"
		cp.set_data strCombo
		VerificaNR = vbNull
	end function

	function RecuperaComboConta(p_cod_prestador_ts, p_mes_ano_ref, p_cod_nr)
		dim rsPesquisa
		dim tabela, registro
		dim strCombo, s_xml
		dim vet_PL(3,4)

		vet_PL(1, 1) = "IN"
		vet_PL(1, 2) = "adVarChar"
		vet_PL(1, 3) = "p_num_grd"
		vet_PL(1, 4) = p_cod_nr
				
		vet_PL(2, 1) = "IN"
		vet_PL(2, 2) = "adInteger"
		vet_PL(2, 3) = "p_cod_prestador_ts"
		vet_PL(2, 4) = p_cod_prestador_ts

		vet_PL(3, 1) = "IN"
		vet_PL(3, 2) = "adVarChar"
		vet_PL(3, 3) = "p_mes_ano_ref"
		vet_PL(3, 4) = p_mes_ano_ref

		set rsPesquisa = rsCursorOracle(CStr(Session("ace_usuario")),_
										CStr(Session("ace_senha")),_
										CStr(Session("ace_ip")),_
										CStr(Session("ace_sistema")),_
										CStr(Session("ace_modulo")),_
										"TS.CTM_OCR_PARAMETRIZACAO.get_combo_contas", _		
										vet_PL, _
										false )

		strCombo = "<select name='cod_ts_conta' id='cod_ts_conta' style='display:' onChange='anexosConta();'>"
	
		if not rsPesquisa.eof then
			strCombo = strCombo & " <option value=''></option>"
			do while not rsPesquisa.eof
				strCombo = strCombo & "<option value='" & rsPesquisa("cod_ts_conta") & "' >" & rsPesquisa("conta") & "</option>"
				rsPesquisa.MoveNext
			loop
		else
			rsPesquisa.close
			set rsPesquisa = nothing
		end if
					
		strCombo = strCombo & " </select>"
		
		cp.set_id "response"
		cp.set_data strCombo
		RecuperaComboConta = vbNull
	end function

	function RecuperaAnexosConta(p_cod_ts_conta, p_mes_ano_ref, p_cod_ts_nr)

		dim rsPesquisa
		dim tblLinha
		dim vet_PL(3,4), qtd_anexos, cod_leitura_doc
		qtd_anexos = 0
			
		vet_PL(1, 1) = "IN"
		vet_PL(1, 2) = "adNumeric"
		vet_PL(1, 3) = "p_cod_ts_conta"
		vet_PL(1, 4) = p_cod_ts_conta
				
		vet_PL(2, 1) = "IN"
		vet_PL(2, 2) = "adVarChar"
		vet_PL(2, 3) = "p_num_grd"
		vet_PL(2, 4) = p_cod_ts_nr

		vet_PL(3, 1) = "IN"
		vet_PL(3, 2) = "adVarChar"
		vet_PL(3, 3) = "p_mes_ano_ref"
		vet_PL(3, 4) = p_mes_ano_ref

		set rsPesquisa =  rsCursorOracle( CStr(session("ace_usuario")),_
										CStr(session("ace_senha")),_
										CStr(session("ace_ip")),_
										CStr(session("ace_sistema")),_
										CStr(session("ace_modulo")),_
										"TS.CTM_OCR_PARAMETRIZACAO.get_contas_anexos", _		
										vet_PL, _
										false )

		tblLinha = "<fieldset class='label_left'>"
		tblLinha = tblLinha & "<table width='100%' id='tbl_anexos2' align='center' style='display:'>"
		tblLinha = tblLinha & "<tr bgcolor='#e2eFe5'>"
		tblLinha = tblLinha & "	<td width='10%' class='label_left'>NR&nbsp;</td>"
		tblLinha = tblLinha & "	<td width='10%' class='label_left'>Conta/Guia&nbsp;</td>"
		tblLinha = tblLinha & "	<td width='10%' class='label_left'>Data&nbsp;</td>"
		tblLinha = tblLinha & "	<td width='20%' class='label_left'>Tipo de documento&nbsp;</td>" 
		tblLinha = tblLinha & "	<td width='40%' class='label_left'>Nome do arquivo&nbsp;</td>"
		tblLinha = tblLinha & "	<td width='5%' class='label_left'>Anexo&nbsp;</td>"
		tblLinha = tblLinha & "	<td width='5%' class='label_left'>OCR&nbsp;</td></tr>"
	
		if not rsPesquisa.eof then
			do while not rsPesquisa.eof
				qtd_anexos = cint(qtd_anexos) + 1
				tblLinha = tblLinha & "<tr><td class='label_left'>" & p_cod_ts_nr & "</td>"
				tblLinha = tblLinha & "<td class='label_left'>" & rsPesquisa("num_guia") & "</td>"
				tblLinha = tblLinha & "<td class='label_left'>" & rsPesquisa("data") & "</td>"
				tblLinha = tblLinha & "<td class='label_left'>" & rsPesquisa("descricao") & "</td>"
				tblLinha = tblLinha & "<td class='label_left' >" & rsPesquisa("nome_arquivo") & "</td>"
				tblLinha = tblLinha & "<td class='label_center' align=center valign=middle>"
				tblLinha = tblLinha & " <a target=blank href='" & rsPesquisa("arquivo_anexo") & "' title='" & rsPesquisa("arquivo_anexo") & "'><img border=0 src='/gen/img/clips_1.gif'></a></td>"
				tblLinha = tblLinha & "<td class='label_center'>"
				cod_leitura_doc = rsPesquisa("cod_leitura_doc")
				if cod_leitura_doc <> "" then
					tblLinha = tblLinha & "<img id='leitura_ocr' style='cursor:pointer;cursor:hand' name='leitura_ocr' id='Pesquisa_Pedido' width='16' height='16' src='/gen/img/conf_exec_.png' border='0' onClick='AbreLeituraOcr("&qtd_anexos&");' title='Leitura OCR'>"
				end if
				tblLinha = tblLinha & "<input type='hidden' name='nom_arq_anexo_" & qtd_anexos & "' id='nom_arq_anexo_" & qtd_anexos & "' value='" & rsPesquisa("nome_arquivo") & "'>"
				tblLinha = tblLinha & "<input type='hidden' name='cod_leitura_doc_" & qtd_anexos & "' id='cod_leitura_doc_" & qtd_anexos & "' value='" & rsPesquisa("cod_leitura_doc") & "'>"
				tblLinha = tblLinha & "</td></tr>"

				rsPesquisa.MoveNext
			loop
		else
			rsPesquisa.close
			set rsPesquisa = nothing
		end if

		tblLinha = tblLinha & "</table>"
		tblLinha = tblLinha & "</fieldset>"
		
		cp.set_id "response"
		cp.set_data tblLinha
		RecuperaAnexosConta = vbNull
	end function
%>