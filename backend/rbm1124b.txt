<%@ LANGUAGE="VBSCRIPT" %>
<%	
	option explicit
	
	dim txt_usuario, txt_senha, txt_ip, txt_modulo, txt_sistema
	dim txt_msg, txt_subtitulo, txt_acao, ind_obriga_observacao
	dim txt_retorno
	
    dim cod_param, acao_linha

	dim ind_guia_tiss
	dim val_confianca_min
	dim cod_tipo_documento, i
	dim cod_tipo_doc_campo, cod_campo, val_confianca ,val_peso ,qtd_campos
	
	'VARIAVEIS DE PROCEDURES
	Dim TopDB, txt_xml
	
	Server.ScriptTimeout = 2800000
	txt_usuario		= Session("ace_usuario")
	txt_senha		= Session("ace_senha")
	txt_ip			= Session("ace_ip")
	txt_modulo		= Session("ace_modulo")
	txt_sistema		= session("ace_sistema")
	
	txt_msg			= Session("txt_msg")
	Session("txt_msg")	= ""
    cod_param               = Request("cod_param")
	txt_subtitulo			= Request.QueryString("PT")
	txt_acao				= ucase(Request.QueryString("txt_acao"))
	txt_xml                 = ""
	val_confianca_min    = Request("val_confianca_min") 
	cod_tipo_documento        = Request("cod_tipo_documento")
	qtd_campos          = Request("qtd_campos")

%>
<!--Include do recordset oracle-->
<!--#include file=..\..\gen\asp\gen0146a.asp-->
<!--#include file=..\..\gen\asp\gen0146b.asp-->

<%

     
txt_xml = txt_xml & "<PARAMETRIZACAO>"
txt_xml = txt_xml & "<V_MIN_CONFIANCA>"&val_confianca_min&"</V_MIN_CONFIANCA>"
txt_xml = txt_xml & "<COD_TIPO_DOCUMENTO>"&cod_tipo_documento&"</COD_TIPO_DOCUMENTO>"
txt_xml = txt_xml & "<QTD_CAMPOS>"&qtd_campos&"</QTD_CAMPOS>"
txt_xml = txt_xml & "<PARAM_CAMPO>"	
for i = 1 To qtd_campos 	
	cod_tipo_doc_campo = Request("cod_tipo_doc_campo_"&i) 
	cod_campo  = Request("cod_campo_"&i)         
	val_confianca  = Request("val_confianca_"&i)
	val_peso =  Request("val_peso_"&i)
	acao_linha = Request("acao_linha_"&i)
	txt_xml = txt_xml & "<COD_TIPO_DOC_CAMPO_"&i&">"&cod_tipo_doc_campo&"</COD_TIPO_DOC_CAMPO_"&i&">"
	txt_xml = txt_xml & "<ACAO_LINHA_"&i&">"&acao_linha&"</ACAO_LINHA_"&i&">"
	txt_xml = txt_xml & "<COD_CAMPO_"&i&">"&cod_campo&"</COD_CAMPO_"&i&">"
	txt_xml = txt_xml & "<CONFIANCA_CAMPO_"&i&">"&val_confianca&"</CONFIANCA_CAMPO_"&i&">"
	txt_xml = txt_xml & "<PESO_DO_CAMPO_"&i&">"&val_peso&"</PESO_DO_CAMPO_"&i&">"
Next
txt_xml = txt_xml & "</PARAM_CAMPO>"
txt_xml = txt_xml & "</PARAMETRIZACAO>"

	if txt_acao <> "" then
		if txt_acao = "I" then
			call incluirParamOcr()
		else
			call editarParamOcr()
		end if
	end if
	Sub incluirParamOcr()
		dim vet_PL(4,4)

        vet_PL(1, 1) = "IN"
        vet_PL(1, 2) = "adLongVarchar"
        vet_PL(1, 3) = "p_xml_parametros"
        vet_PL(1, 4) = txt_xml
        
        vet_PL(2, 1) = "IN"
        vet_PL(2, 2) = "adVarchar"
        vet_PL(2, 3) = "p_cod_usuario"
        vet_PL(2, 4) = txt_usuario

        vet_PL(3, 1) = "OUT"
        vet_PL(3, 2) = "adVarchar"
        vet_PL(3, 3) = "p_cod_retorno"

        vet_PL(4, 1) = "OUT"
        vet_PL(4, 2) = "adVarchar"
        vet_PL(4, 3) = "p_msg_retorno"

		 Call ExecutaPLOracle (	CStr(txt_usuario),_
	  						CStr(txt_senha),_
							CStr(txt_ip),_
							CStr(txt_sistema),_
							CStr(txt_modulo),_
                            "TS.rbm_consulta_leitura_OCR_previa.set_param_previa_ocr", _
							vet_PL, _
							false )
		
					Session("txt_msg") = vet_PL(4, 4)
				set TopDB = nothing
	end sub
	Sub editarParamOcr()
		
		dim vet_PL(5,4)

        vet_PL(1, 1) = "IN"
        vet_PL(1, 2) = "adLongVarchar"
        vet_PL(1, 3) = "p_xml_parametros"
        vet_PL(1, 4) = txt_xml

		vet_PL(2, 1) = "IN"
        vet_PL(2, 2) = "adInteger"
        vet_PL(2, 3) = "p_cod_param"
        vet_PL(2, 4) =  cod_param
        
        vet_PL(3, 1) = "IN"
        vet_PL(3, 2) = "adVarchar"
        vet_PL(3, 3) = "p_cod_usuario"
        vet_PL(3, 4) = txt_usuario

        vet_PL(4, 1) = "OUT"
        vet_PL(4, 2) = "adVarchar"
        vet_PL(4, 3) = "p_cod_retorno"


        vet_PL(5, 1) = "OUT"
        vet_PL(5, 2) = "adVarchar"
        vet_PL(5, 3) = "p_msg_retorno"

		Call ExecutaPLOracle (	CStr(txt_usuario),_
	  						CStr(txt_senha),_
							CStr(txt_ip),_
							CStr(txt_sistema),_
							CStr(txt_modulo),_
                            "TS.rbm_consulta_leitura_OCR_previa.atualiza_param_previa_ocr", _
							vet_PL, _
							false )
		
				Session("txt_msg") = vet_PL(5, 4)
		set TopDB = nothing		
	end Sub
	    Response.Redirect "rbm1124a.asp?PT="& txt_subtitulo
	    Response.End
	
%>