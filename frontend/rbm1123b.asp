<%@ LANGUAGE="VBSCRIPT" %>
<%
	'-----------------------------------------------------------
	'-  Carta Reembolso
	'-  Autor: Jose Leandro Vieira Pordeus
	'-  Criação: 28/08/2025
	'-----------------------------------------------------------

	option explicit

	dim txt_usuario, txt_senha, txt_ip, txt_modulo
	dim txt_msg, txt_subtitulo
	dim num_tabindex, num_reembolso
	dim oPesquisa, rsPesquisa, ind_reexecute
	
	dim ind_acesso_cam, txt_readonly, ind_popup, ind_voltar, ind_limpar
	dim qtd_resultado
		
	qtd_resultado = 0
	txt_readonly = ""
	ind_voltar  = "N"
	ind_popup  = "N"
	ind_limpar = "S"
		
	txt_usuario = Session("ace_usuario")
	txt_senha   = Session("ace_senha")
	txt_ip      = Session("ace_ip")
	txt_modulo  = Session("ace_modulo")
	
	num_reembolso = Request("num_reembolso")
	ind_reexecute  = Request("ind_reexecute")

	if trim(txt_modulo) = "" then
		txt_modulo = Request.QueryString("pm")
		Session("ace_modulo") = txt_modulo
	end if

	txt_msg       = Session("txt_msg")
	txt_subtitulo = Request.QueryString("PT")

	Session("txt_msg")     = ""	
	session("pgm_retorno") = Request.ServerVariables("SCRIPT_NAME") & "?pt=" & txt_subtitulo & "&ind_acesso_cam=" & ind_acesso_cam '& "&num_reembolso=" & num_reembolso  

	num_tabindex = 0
	
	if ind_acesso_cam = "S" or txt_modulo = 40 then	
		ind_reexecute = "S"
		ind_voltar = "S"
		ind_popup = "S"
		ind_limpar = "N"		
	end if
		
%>
<!--#include file=..\..\gen\asp\gen0146a.asp-->
<!--#include file=..\..\gen\asp\gen0146b.asp-->
<%
	    
	if num_reembolso <> "" then

		Dim VetParam(3,4)
		
		VetParam(1, 1) = "IN"
		VetParam(1, 2) = "adVarchar"
		VetParam(1, 3) = "p_num_reembolso"
		VetParam(1, 4) = num_reembolso
		
		VetParam(2, 1) = "OUT"
		VetParam(2, 2) = "adDouble"
		VetParam(2, 3) = "p_cod_retorno"
		
		VetParam(3, 1) = "OUT"
		VetParam(3, 2) = "adVarchar"
		VetParam(3, 3) = "p_msg_retorno"		

		Set rsPesquisa =  rsCursorOracle (	CStr(Session("ace_usuario")),_
											CStr(Session("ace_senha")),_
											CStr(Session("ace_ip")),_
											CStr(Session("ace_sistema")),_
											CStr(Session("ace_modulo")),_
											"RBM_CONSULTA_LEITURA_OCR_PREVIA.get_rs_pedidos_ativos_ocr", _
											VetParam, _
											false ) 
			
		if VetParam(2, 4) = 9 then
			txt_msg = VetParam(3, 4)
			num_reembolso = ""
		else
			qtd_resultado = rsPesquisa.recordCount			
			if qtd_resultado = 0 then
				  txt_msg = "Reembolso "& num_reembolso &" não tem anexo."
				  num_reembolso = ""
			end if  
		end if  
											
	end if		
   
%>

<html>
<head>
<title><%=Application("app")%></title>
<link href="\gen\css\css002.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="../../gen/modal/modal.util.js"></script>

<!--#include file=..\..\gen\inc\inc0000.asp-->
<!--#include file=..\..\gen\inc\inc0001.asp-->
<!--#include file=..\..\gen\inc\inc0002.asp-->

<script language="JavaScript">

function ValidaForm() {

    var n = form01.qtd_reembolsos.value;
    var q = 0;
	
    for (var i = 1; i <= n; i++) {
        if (document.getElementById("ind_reembolso_" + i).checked == true) {
            q++;
        }
    }

    if (q < 1) {
        alert("Selecione o(s) reembolso(s) que deseja imprimir");
        return false;
    }
	
	
	
    return true;
}

function reexecute()
{	
	form01.ind_reexecute.value = "S";
	document.form01.action = "<%=session("pgm_retorno")%>";
	document.form01.submit();
}

function AlteraIcone(i) {
	var imgElement = document.getElementById("clips_" + i);
	if (imgElement) {
		imgElement.src = "\\gen\\img\\clips_1_pb.gif";
		  
	}		  
}

function acao_continuar() {
    if (ValidaForm()) {
        document.form01.action = 'rbm1123b.asp?PT=<%=txt_subtitulo%>';
		document.form01.submit();
	}
}

function acao_voltar(){
	try {
		closeModal();
    } catch (e) {
        parent.self.close();
    }
}



function abrePesquisaReembolso() {
	if( document.form01.num_reembolso.value == "" ){
		AbrePesquisa('../../gen/asp/gen0167a.asp?ind_situacao=2&ind_previa_memoria=S&indsubmit=N&nome_campo_cod=num_reembolso&nome_campo_cod_ts=&nome_campo_desc=&txt_nome_campo_cod=num_reembolso&txt_nome_campo_cod_ts=&txt_nome_campo_desc=&abre_modal=S&funcao_executar=reexecute()', 'Pesquisa_Reembolso', 'Pesquisa Prévia', 1000, 500, 20, 15, 'S')
	}
}

function selecionar(k) {
    var n = form01.qtd_reembolsos.value;
    for (var i = 1; i <= n; i++) {
      document.getElementById("ind_reembolso_" + i).checked = k.checked ;
    }    
}

if (typeof abrePesquisaReembolso !== 'function') {
  alert('Função abrePesquisaReembolso não foi carregada!');
}
</script>






</head>

<%AbreTable()%>
<font class="subtitulos"><%=txt_subtitulo%></font>
<%FechaTable()%>

<%AbreTable()%>
<div id="txt_msg" class="msg" align="center"><%=txt_msg%></div>
<form method="post" name="form01">

<table width="100%" align="left">
	<tr>
		<td class="label_left">&nbsp;Nº Prévia:&nbsp;
			<input type="text" name="num_reembolso" value="<%=num_reembolso%>" size="25" maxlength="20" tabindex="<%=cInt(num_tabindex)+1%>" onKeyPress="MascInt();" onChange="reexecute();" <%if num_reembolso <> "" then%>readonly class="camposblocks"<%end if%> />
			<%if num_reembolso = "" then%>
				<img name="Pesquisa_Reembolso" width="16" height="16" id="Pesquisa_Reembolso" style="cursor: hand;" onclick="abrePesquisaReembolso();" alt="Pesquisa Prévia" src="/gen/mid/lupa.gif" border="0"/>
			<%end if%>
		</td>
	</tr>

	
</table>
<%FechaTable()%>
<br/>
<% if ind_reexecute ="S" and qtd_resultado > 0 then %>
	
<br/>
<%AbreTable()%>
<table border=0 width="100%">

    <tr>
       
         <tr bgcolor="#e2eFe5">
			<td width="4%" class="label_left">Data&nbsp;</td>
			<td width="4%" class="label_left">Tipo de documento&nbsp;</td>
            <td width="20%" class="label_left">Nome do arquivo&nbsp;</td>>
        </tr>
    </tr>
    <%
        dim i
        i = 1
        while rsPesquisa.eof = false 
        %>
        
        <tr>           
            <td><%=rsPesquisa("dt_anexado") %></td>
             <td><%=rsPesquisa("nom_tipo_anexo") %></td>
			<td><%=rsPesquisa("nom_arq_anexo") %></td>
			
        <% 
        i = i + 1
        rsPesquisa.moveNext
        wend
        %>

</table>
<input type="hidden" name="qtd_reembolsos" value="<%=qtd_resultado %>" />

<%FechaTable()%>

<%end if %>


<input type="hidden" name="ind_reexecute" value="<%=ind_reexecute %>" />

</form>
<%
	'VOLTAR/CONTINUAR/LIMPAR/INCLUIR/ALTERAR/EXCLUIR/EXECUTAR/POPUP
	if ind_reexecute = "S" and qtd_resultado > 0 then	
		call MontaToolbar(ind_voltar,"N",ind_limpar,"N","N","N","N",ind_popup)
	else
		call MontaToolbar("N","S","S","N","N","N","N","N")
	end if
  
%>
</body>
</html>