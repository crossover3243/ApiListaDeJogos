<%@ LANGUAGE="VBSCRIPT" %>
<%

	option explicit

	dim txt_subtitulo, txt_msg
	dim pgm_atual
	Dim sUsuario, sSenha, sIP, sModulo, sSistema
	Dim rsPesquisa, txt_acao, codigo_chave, ind_acao
	Dim cod_param, txt_descricao
	Dim ind_guia_tiss
	Dim ind_valida_qrcode
	Dim ind_tipo_guia
	Dim cod_tipo_documento
	Dim cod_tipo_documento_filtro
	dim nom_tipo_documento
	dim nom_tipo_documento_filtro
	dim txt_selected
	dim val_confianca_min
	dim txt_combo_campos
	dim ind_consultar 
	dim cod_tipo_doc_campo
	dim	nom_tipo_doc_campo
	
    
    	
	'--------------------------------

	sUsuario	= Session("ace_usuario")
	sSenha		= Session("ace_senha")
	sIP			= Session("ace_ip")
	sModulo		= Session("ace_modulo")
	sSistema	= session("ace_sistema")


	txt_msg			= session("txt_msg")

	txt_subtitulo	= Request.QueryString("PT") 

	pgm_atual	= Request.ServerVariables("SCRIPT_NAME") & "?" & Request.ServerVariables("QUERY_STRING")

	session("pgm_retorno")	= pgm_atual
	
    cod_param = ""

	
	 if Request("ind_consultar") = "S" then
		ind_consultar = "S"
		if Len(Request("mensagem")) then
			txt_msg = Request("mensagem")
		end if
    else
		ind_consultar = "N"
    end if


    If Request("txt_acao") = "I" then
		txt_acao = "I"
		codigo_chave = Request("codigo_chave")
		If Len(codigo_chave) > 0 Then
			cod_param = codigo_chave
			cod_tipo_documento = codigo_chave
		End If
    ElseIf Request("txt_acao") = "A" Then
		txt_acao = "A"
		codigo_chave = Request("codigo_chave")
		If Len(codigo_chave) > 0 Then

			Redim vet_PL(1, 4)
			
			'-------------------------------------------------

			'-------------------------------------------------
			vet_PL(1, 1) = "IN"
			vet_PL(1, 2) = "adInteger"
			vet_PL(1, 3) = "p_cod_param"
			vet_PL(1, 4) = codigo_chave

			Set rsPesquisa = rsCursorOracle(CStr(sUsuario), _
											CStr(sSenha), _
											CStr(sIP), _
											CStr(sSistema), _
											CStr(sModulo),_
											"TS.rbm_consulta_leitura_OCR_previa.get_param_ocr_doc", _
											vet_PL, _
											false )
			If not rsPesquisa.eof Then
				cod_param = rsPesquisa("cod_param")
				val_confianca_min = rsPesquisa("val_confianca_min")
				cod_tipo_documento = rsPesquisa("cod_tipo_documento")
				nom_tipo_documento = rsPesquisa("nom_tipo_documento")
			End If
			rsPesquisa.close
			set rsPesquisa = nothing

		End If
	Else 
		txt_acao = "N"
    End If

%>
<HTML>
<HEAD>
<title><%=Application("app")%></title>
<link href="\gen\css\css002.css" rel="stylesheet" type="text/css">
<style type=text/css>
	.caixaNovaParametrizacao { padding: 10px }
	.dicaInformativa { color: gray; padding: 10px }
	.grid-cell { padding: 5px; }
	.td-cod-principal { width:115px }
	.campos_param { margin-top: 10px }

	/* Componente de listas seleção - início */
	.component {
		
	}
	.parametrizado {
		color: green;	
	}
	.naoParametrizado {
		color: red;
	}

	.title {
		background-color: #28235c;
		color: white;
		padding: 8px 0px 8px 15px;
		border-radius: 8px 8px 0px 0px;
	}

	.lista {
		padding: 10px 10px 10px 10px;
	}

	.td-margin {
		width: 10px;
	}

	.columnButton {
		width: 50px;
	}

	#divAvailableList {
		width: 100%;
	}

	#availableList {
		width: 100%;
		height: 200px;
	}

	#divSelectedList {
		width: 100%;
	}

	#selectedList {
		width: 100%;
		height: 200px;
	}

	#adicionarButton {
		width: 100px;
	}
	
	#removerButton {
		width: 100px;
	}

	/* Componente de listas seleção - fim */
		
</style>
<!-- Contem as funções javascript para a Parametrização de Tratamentos Contínuos -->
</HEAD>
<!--#include file=..\..\gen\inc\inc0000.asp-->
<!--#include file=..\..\gen\inc\inc0001.asp-->
<!--#include file=..\..\gen\inc\inc0002.asp-->
<!--Include do recordset oracle-->
<!--#include file=..\..\gen\asp\gen0146a.asp-->
<!--#include file=..\..\gen\asp\gen0146b.asp-->
<BODY>
<%AbreTable()%>
<font class="subtitulos"><%=txt_subtitulo%></font>
<%FechaTable()%>

<%Call SetWaitBar()%>

<%AbreTable()%>
<div id="txt_msg" class="msg" align="center"><%=txt_msg%></div>

<form method="POST" name="form01">

<input type="hidden" name="ind_acao" value="<%=ind_acao%>">
<input type="hidden" name="ind_consultar" value="S" />
<input type="hidden" name="txt_acao" value="N" />
<input type="hidden" name="codigo_chave" value="" />
<input type="hidden" name="mensagem" value="" />


<%If txt_acao = "I" Or txt_acao = "A" Then %>
	
	<table width="100%" align="center">

		<tr>
			<td width="120px" class="label_right">Código:&nbsp;</td>
			<td>
				<input type='text' Readonly class="camposblocks"  value="<%=cod_tipo_documento%>" size="10"  onKeyPress ="javascript:MascInt()">
				<input type='hidden' name='cod_param' id='cod_param' value="<%=cod_param%>" size="10"  onKeyPress ="javascript:MascInt()">
			</td>
		</tr>
		<tr>
		<% if nom_tipo_documento = "" then
		   call montaTipoDoc(cod_param)
		else %>
		   <td width="120px" class="label_right">Tipo de documento:&nbsp;</td>
		   		<td>
				  <input type='text' Readonly class="camposblocks" name='nom_tipo_documento' id='nom_tipo_documento' size="60" value="<%=nom_tipo_documento%>"  onKeyPress ="javascript:MascInt()">
				  <input type='hidden' Readonly class="camposblocks" name='cod_tipo_documento' id='cod_tipo_documento' value="<%=cod_tipo_documento%>"  onKeyPress ="javascript:MascInt()">
			    </td>
		 <%end if%>
		</tr>
		<!--
		<tr>
			<td width="120px" class="label_right">Confiança mínima de validação da guia:&nbsp;</td>
			<td>
				<input type='number' name='val_confianca_min' value="<%=val_confianca_min%>" onChange="formataPorcentagem();" maxlength="100" onKeyPress ="javascript:MascNum();verificaNumero();" >%		
			</td>
		</tr>
		-->

	</table>

<% else %>
	<table width="100%" align="center">

		<tr>
			<td class="caixaNovaParametrizacao">
				<input type='button' name='btnNovaParametrizacao' value='Nova Parametrização' onClick='CarregarNovaParametrizacao();' style='cursor:hand'  tittle='Carregar código para uma nova parametrização'>		
			</td>
		</tr>
		<%
		if ind_consultar <> "S" then %>
			<tr>
				<td class="dicaInformativa">Pressione a tecla <b>Continuar</b> para relacionar as parametrizações já cadastradas</td>
			</tr>
		<% end if %>
	</table>
<% end if %>

<%FechaTable()%>

<%if ind_consultar = "S" And txt_acao <> "I" And txt_acao <> "A" then %>
<%AbreTable()%>
    <table width="100%" border="0">
        <tr>
            <td class="grid_cabec" width="98%"><h1 class="grid_cabec"><label><font align="center" class="label_left"><b>&nbsp;Parametrizações Cadastradas</b></label></h1></td>
            <td class="label_right" ><h1 class="grid_cabec"><img id="img_dv_cadastrados" src="../../gen/img/btn-up.jpg" width="16" height="12" onClick="Expandir('dv_cadastrados');" style="cursor:hand" title="Clique para exibir a Parametrização de Tratamentos Contínuos cadastrados" /></h1></td>
        </tr>
    </table>
	<tr><div id="dv_cadastrados"><fieldset><% Call MontaCadastrados() %></fieldset></div></tr>
<%FechaTable()%>	
<% end if %>

<%If txt_acao = "I" Or txt_acao = "A" Then %>
	<%AbreTable()%>

			<tr>
				<% 
				Call montaCamposParam(cod_param)
				   Call montaCamposTipoDoc(cod_tipo_documento) %>
			</tr>
	<%FechaTable()%>	

<% end if %>

<script type="text/javascript">
    window.onload = function() {
        var descricaoInput = document.forms[0].elements["txt_descricao"];
        if (descricaoInput) {
            descricaoInput.focus();
			descricaoInput.select();
        }
    };
</script>

</form>

<%
sub montaTipoDoc(cod_param)
	
%>
	<td width="120px" class="label_right">Tipo de documento:&nbsp;</td>
			<td>
				

<select name="cod_tipo_documento" id="cod_tipo_documento" onChange="CarregarNovaParametrizacao();">
  <option value=""></option>


				<%
					if cod_param = "" then
						cod_param = 0
					end if

					Redim vet_PL(1, 4)
					vet_PL(1, 1) = "IN"
					vet_PL(1, 2) = "adVarchar"
					vet_PL(1, 3) = "p_cod_param"
					vet_PL(1, 4) = cod_param
					Set rsPesquisa = rsCursorOracle(CStr(sUsuario), _
													CStr(sSenha), _
													CStr(sIP), _
													CStr(sSistema), _
													CStr(sModulo),_
													"rbm_consulta_leitura_OCR_previa.get_tipo_documento", _
													vet_PL, _
													false )
					do while not rsPesquisa.eof
						cod_tipo_documento_filtro         = rsPesquisa("cod_tipo_documento")
						nom_tipo_documento_filtro        = rsPesquisa("nom_tipo_documento")
						
						if (cod_param = cod_tipo_documento_filtro) then
						%>
							<option value="<%=cod_tipo_documento_filtro%>" selected><%=nom_tipo_documento_filtro%>  </option>
						<%
						else 
						%>
							<option value="<%=cod_tipo_documento_filtro%>"><%=nom_tipo_documento_filtro%></option>
						<%
						end if
						rsPesquisa.movenext
					loop
					rsPesquisa.close
			        set rsPesquisa = nothing
				%>	
				</select>	
			</td><%
end sub


sub montaCamposTipoDoc(cod_tipo_documento)

	dim vet_PL(2,4)

	vet_PL(1, 1) = "IN"
	vet_PL(1, 2) = "adVarchar"
	vet_PL(1, 3) = "p_log"
	vet_PL(1, 4) = "S"
	
	vet_PL(2, 1) = "IN"
	vet_PL(2, 2) = "adVarchar"
	vet_PL(2, 3) = "p_cod_tipo_documento"
	vet_PL(2, 4) = cod_tipo_documento

					Set rsPesquisa = rsCursorOracle(CStr(sUsuario), _
													CStr(sSenha), _
													CStr(sIP), _
													CStr(sSistema), _
													CStr(sModulo),_
													"TS.rbm_consulta_leitura_OCR_previa.get_combo_tipo_doc_campo", _
													vet_PL, _
													false )
					do while not rsPesquisa.eof
						cod_tipo_doc_campo         = rsPesquisa("cod_tipo_doc_campo")
						nom_tipo_doc_campo        = rsPesquisa("nom_tipo_doc_campo")
						

						
						txt_combo_campos = txt_combo_campos & "<option value=" & cod_tipo_doc_campo & ">" & nom_tipo_doc_campo & "</option>"
						
						rsPesquisa.movenext
					loop
					rsPesquisa.close
			        set rsPesquisa = nothing
end sub

sub montaCamposParam(cod_param)
    
        Dim vet_PL(1, 4), classe
		Dim cod_tipo_doc_campo          
	    Dim nom_tipo_doc_campo     
		Dim val_confianca
		Dim val_peso		
		Dim cod_campo	
		Dim ind      
            
			vet_PL(1, 1) = "IN"
            vet_PL(1, 2) = "adInteger"
            vet_PL(1, 3) = "p_cod_param"
            vet_PL(1, 4) = cod_param

            Set rsPesquisa =  rsCursorOracle ( CStr(session("ace_usuario")),_
                                                    CStr(session("ace_senha")),_
                                                    CStr(session("ace_ip")),_
                                                    CStr(session("ace_sistema")),_
                                                    CStr(session("ace_modulo")),_
                                                    "TS.rbm_consulta_leitura_OCR_previa.get_param_ocr_campos", _
                                                    vet_PL, _
                                                    false )
        %>
		<td colspan="5">
		<fieldset>
		<table border="0" width="100%" align="center" id="tbl_campos_param">	
		<tr>
			<td colspan="8" class="grid_cabec" align="center" width="100%"><b>Parametrização - Campos do documento</b></td>				
		</tr>
			<tr>
				<td class="grid_cabec" width="60%" align="center"><b>Campo</b></td>
				<td class="grid_cabec" width="25%" align="center"><b>Confiança</b></td>
				<td class="grid_cabec" width="25%" align="center"><b>Peso</b></td>
				<td class="grid_cabec" width="15%" align="center"><b>Excluir</b></td>
			</tr>
        <%
		ind = 0
        if not rsPesquisa.EOF then
            do while not rsPesquisa.EOF
                ind = ind + 1
				cod_tipo_doc_campo = rsPesquisa("cod_tipo_doc_campo")
				nom_tipo_doc_campo = rsPesquisa("nom_tipo_doc_campo")   
				val_confianca     = rsPesquisa("val_confianca")
				val_peso    	 =  rsPesquisa("val_peso")
				cod_campo         = rsPesquisa("cod_campo")
                if ind mod 2 = 0 then
                    classe = "grid_center06"
                else
                    classe = "grid_center"
                end if
            
                %>

                <tr class="<%=classe%>" >              
					<td>
						<input type='text' name='txt_descricao_<%=ind%>' Readonly class="camposblocks" name='txt_descricao_<%=ind%>' value="<%=nom_tipo_doc_campo%>" onChange="alteraCampo(<%=ind%>);" size="60"  maxlength="100">		
					</td> 
					<td>
						<input type='number' name='val_confianca_<%=ind%>' id='val_confianca_<%=ind%>' value="<%=val_confianca%>" maxlength="3" onKeyPress ="javascript:MascNum();verificaNumero();" onChange="formataConfianca(<%=ind%>);alteraCampo(<%=ind%>);" >%
					</td>
					<td>
						<input type='number' name='val_peso_<%=ind%>' id='val_peso_<%=ind%>' value="<%=val_peso%>" maxlength="3" onKeyPress ="javascript:MascNum();verificaNumero();" onChange="formataConfianca(<%=ind%>);alteraCampo(<%=ind%>);" >%
					</td>
					<td>
						<input type='checkbox' name='acao_excluir_<%=ind%>' id='acao_excluir_<%=ind%>' onClick="excluirCampo(<%=ind%>);">		
					</td>
					<input type="hidden" name="cod_campo_<%=ind%>" id="cod_campo_<%=ind%>" value="<%=cod_campo%>" >
					<input type="hidden" name="acao_linha_<%=ind%>" id="acao_linha_<%=ind%>" value="N" > 
					<input type="hidden" name="cod_tipo_doc_campo_<%=ind%>" id="cod_tipo_doc_campo_<%=ind%>" value="<%=cod_tipo_doc_campo%>" >		
                </tr>
                <%
                rsPesquisa.movenext
            loop				
            rsPesquisa.close
            set rsPesquisa = nothing					
        else
        end if
        %>
         </table>
				<br />
				<center>
					<input type="button" value="Adicionar Campo" onclick="adicionarLinha();" id="btnAdicionar" NAME="btnAdicionar">
				</center>
				<input type="hidden" name="qtd_campos" id="qtd_campos" value="<%=ind%>">
				<br />
			</fieldset>
		</td>
        <%
    end sub

'VOLTAR/CONTINUAR/LIMPAR/INCLUIR/ALTERAR/EXCLUIR/EXECUTAR
select case txt_acao
case "I"
	call MontaToolbar("S","N","S","S","N","N","N","N")
case "A"
	call MontaToolbar("S","N","S","N","S","N","N","N")
case else
	call MontaToolbar("N","S","N","N","N","N","N","N")
end select

%>


<!-- BEGIN: Filtro dinâmico para evitar opções repetidas nos selects de "Campo" -->
<select id="model_combo_campos" style="display:none"><%=txt_combo_campos%></select>

<script type="text/javascript">
(function(){
    function getAllOptions(){
        var modelo = document.getElementById("model_combo_campos");
        if (!modelo) return [];
        var out = [];
        for (var i = 0; i < modelo.options.length; i++) {
            var opt = modelo.options[i];
            if (opt.value !== "") {
                out.push({ value: opt.value, text: opt.text });
            }
        }
        return out;
    }

    function getAllSelects(){
        var selects = document.getElementsByTagName("select");
        var result = [];
        for (var i = 0; i < selects.length; i++) {
            if (selects[i].name.indexOf("cod_tipo_doc_campo_") === 0) {
                result.push(selects[i]);
            }
        }
        return result;
    }

    function getSelectedValues(ignoreSelect) {
        var values = {};
        var selects = getAllSelects();
        for (var i = 0; i < selects.length; i++) {
            if (selects[i] === ignoreSelect) continue;
            var val = selects[i].value;
            if (val) values[val] = true;
        }
        return values;
    }

    function populateFilteredOptions(select) {
        var selected = select.value;
        var all = getAllOptions();
        var usados = getSelectedValues(select);

        while (select.options.length) select.remove(0);

        var optVazio = document.createElement("option");
        optVazio.value = "";
        optVazio.text = "";
        select.appendChild(optVazio);

        for (var i = 0; i < all.length; i++) {
            if (!usados[all[i].value] || all[i].value === selected) {
                var o = document.createElement("option");
                o.value = all[i].value;
                o.text = all[i].text;
                select.appendChild(o);
            }
        }

        select.value = selected;
        if (select.value !== selected) select.value = "";
    }

    function refiltrarTodos() {
        var selects = getAllSelects();
        for (var i = 0; i < selects.length; i++) {
            populateFilteredOptions(selects[i]);
        }
    }

    function interceptarAdicao() {
        var antiga = window.adicionarLinha;
        window.adicionarLinha = function() {
            var disponiveis = getAllOptions().filter(function(op) {
                return !getSelectedValues()[op.value];
            });
            if (disponiveis.length === 0) {
                alert("Todos os campos já foram utilizados.");
                return false;
            }
            if (typeof antiga === "function") antiga();
            setTimeout(() => {
                var selects = getAllSelects();
                if (selects.length > 0) {
                    var ultimo = selects[selects.length - 1];
                    populateFilteredOptions(ultimo);
                    ultimo.addEventListener("change", refiltrarTodos);
                }
                refiltrarTodos();
            }, 50);
        };
    }

    function setupInicial(){
        var selects = getAllSelects();
        for (var i = 0; i < selects.length; i++) {
            selects[i].addEventListener("change", refiltrarTodos);
        }
        refiltrarTodos();
        interceptarAdicao();
    }

    if (document.readyState === "complete" || document.readyState === "interactive") {
        setTimeout(setupInicial, 10);
    } else {
        document.addEventListener("DOMContentLoaded", setupInicial);
    }
})();
</script>
<!-- END: Filtro dinâmico -->

</body>
</HTML>


<%
private Sub MontaCadastrados()
        Dim iContLinha
		dim classe
	%>
	<table border="0" width="70%" align="center" id="tbCadastrados">
		<tr>
			<td width="15%"  class="grid_cabec grid-cell" align=center><b>Código</b></td>
			<td width="55%"  class="grid_cabec grid-cell" align=center><b>Descrição</b></td>
		</tr>
	    <%
	    iContLinha = "0"
        
        Redim vet_PL(1, 4)
        
        '-------------------------------------------------
        'CARREGAR PARAMETRIZAÇÃO DE TRATAMENTO CONTINUO
        '-------------------------------------------------
        vet_PL(1, 1) = "IN"
        vet_PL(1, 2) = "adInteger"
        vet_PL(1, 3) = "p_cod_param"
        vet_PL(1, 4) = ""

        Set rsPesquisa = rsCursorOracle(CStr(sUsuario), _
 					                    CStr(sSenha), _
					                    CStr(sIP), _
					                    CStr(sSistema), _
					                    CStr(sModulo),_
					                    "TS.rbm_consulta_leitura_OCR_previa.get_param_ocr_doc", _
					                    vet_PL, _
					                    false )
        do while not rsPesquisa.eof 
            iContLinha = Cint(iContLinha) + 1
            			
			dim cod_param
			cod_param = rsPesquisa("cod_param")
	
			%>
				<tr  id="linha_<%=rsPesquisa("cod_param")&"_"&iContLinha%>">
					<td  id="grid_1<%=iContLinha%>" class="grid_center03 grid-cell">
						<a href="#" onclick="editarRegistro('<%=Server.HTMLEncode(cod_param)%>')">
							<%= rsPesquisa("COD_TIPO_DOCUMENTO") %>
						</a>						
					</td>
					<td  id="grid_2<%=iContLinha%>" class="grid_center03 grid-cell">
						<a href="#" onclick="editarRegistro('<%= Server.HTMLEncode(cod_param) %>')">
							<%=rsPesquisa("nom_tipo_documento")%>
						</a>
					</td>
				</tr>		
	        <% 
            rsPesquisa.movenext
        loop
        rsPesquisa.close
        set rsPesquisa = nothing
	    %>
    </table>
	<%
	
End Sub

'------------------------------------------------------------------
%>


<script src="\gen\js\waitbar.js" type="text/javascript"></script>
<script type="text/javascript" defer="defer">



//------------------------------------------------------------------
function trim(str) {
    return str.replace(/^\s+|\s+$/g, '');
}
//------------------------------------------------------------------
function reexecute(form01) {
    MostrarWait();
	document.form01.action = "<%=session("pgm_retorno")%>";
	document.form01.submit();
}
//------------------------------------------------------------------
function acao_incluir() {
	if (Validacao()==false)
		return false;
	ExecutaGravacao('I');
}

function Validacao() {

	if (document.getElementById("cod_tipo_documento").value == ''){
        alert('Campo Tipo de documento é Obrigatório');
        return false;
    }
	if(!validaCodCampo()){
		alert('Um campo está sendo parametrizado mais de uma vez');
        return false;
	}

	if(!validaConfianca()){
		alert('O campo Confiança é obrigatório para a leitura OCR');
        return false;
	}

	return true;
}

function validaConfianca(){
	var qtd_campos = document.getElementById("qtd_campos").value;

	qtd_campos = parseInt(qtd_campos);
	for(i = 1; i <= qtd_campos; i++){
		if(document.getElementById("val_confianca_"+i).value == ""){
			return false;
		}
	}
	return true;
}

function validaCodCampo(){
	var qtd_campos = document.getElementById("qtd_campos").value;
	var num1;
	var num2;
	var cont = 0;
	var excluir;

	qtd_campos = parseInt(qtd_campos);
	for(i = 1; i <= qtd_campos; i++){
		num1 = document.getElementById("cod_tipo_doc_campo_"+i).value;
		cont = 0;

		for(index = 1; index <= qtd_campos; index++){
			num2 = document.getElementById("cod_tipo_doc_campo_"+index).value;
			excluir = document.getElementById("acao_excluir_"+ index);
			if(num1 == num2 && num1 != "" && num2 != "" && !excluir.checked){
				cont++;
			}
			if(cont > 1){
				return false;
			}
		}
	}
	return true;
}

//------------------------------------------------------------------
function acao_alterar() {	
	if (Validacao()==false)
		return false;
	ExecutaGravacao('A');
	return true;
}
//------------------------------------------------------------------
function acao_excluir() {
	var confirmacao = confirm("Tem certeza que deseja excluir esta parametrização?");
	if (confirmacao) {
		ExecutaGravacao('E');
	}
}
//------------------------------------------------------------------
function ExecutaGravacao(pIndAcao) {

	var qtd_campos = document.getElementById('qtd_campos').value;

    document.form01.action='rbm1124b.asp?PT=<%=txt_subtitulo%>&txt_acao='+pIndAcao
	document.form01.submit();
}
//------------------------------------------------------------------
function valida_form(){

    return true;
}

function CarregarNovaParametrizacao(){
	try {
		form01.codigo_chave.value = document.getElementById('cod_tipo_documento').value; 
	} catch(e){}; 
	
	document.getElementById('txt_acao').value = 'I';
	reexecute();
}

function alteraCampo(linha){
	document.getElementById("acao_linha_"+linha).value = 'A';
}

function excluirCampo(linha){
	var excluir = document.getElementById("acao_excluir_"+linha);
	if(excluir.checked){
		document.getElementById("acao_linha_"+linha).value = 'E';
	}
	else{
		document.getElementById("acao_linha_"+linha).value = 'N';
	}
}

function mostraGravacao(pMensagem) {
	var retorno = pMensagem.ajaxResponse[0].data;
	var partes = retorno.split('|');
	
	form01.mensagem.value = partes[1];
	form01.txt_acao.value = "N";  
	form01.ind_consultar.value = "S";
	if (partes[0] == '0') {
		form01.action = '<%=session("pgm_retorno")%>';
		form01.submit();
	} else {
		alert(partes[1]);
	}
}

//------------------------------------------------------------------
function limparMensagem() {
	<% Session("txt_msg") = ""%>
	var mostradorMessagem = document.getElementById('txt_msg');
	mostradorMessagem.style.display = '';
	mostradorMessagem.innerHTML = "";
}

//-------------------------------------------------------------------------------------------
function editarRegistro(cod_param) {
	MostrarWait();
	limparMensagem();
    form01.txt_acao.value = "A";  // Alterar
	form01.ind_consultar.value = "N";
	form01.codigo_chave.value = cod_param;
	form01.action = '<%=session("pgm_retorno")%>';
	form01.submit();
}
//-------------------------------------------------------------------------------------------
function adicionarLinha() {

	var total_itens;
	
	total_itens = document.getElementById('qtd_campos').value;
	total_itens =  parseInt(total_itens) + 1;

    document.getElementById('qtd_campos').value = total_itens;

    var coluna_1 = '<center><select name="cod_tipo_doc_campo_'+ total_itens+'"><%=txt_combo_campos%></select></center>'; 

	var coluna_2  = '<center><input type="number" name="val_confianca_'+ total_itens+'" id="val_confianca_'+ total_itens+'" maxlength="3" onChange="formataConfianca('+ total_itens+');" onKeyPress ="javascript:MascNum();verificaNumero();" >%</center>';
	
	var coluna_3  = '<center><input type="number" name="val_peso_'+ total_itens+'" id="val_peso_'+ total_itens+'" maxlength="3" onChange="formataConfianca('+ total_itens+');" onKeyPress ="javascript:MascNum();verificaNumero();" >%</center>';
						
	var coluna_4 = '<center><input type="checkbox" name="acao_excluir_'+ total_itens+'" id="acao_excluir_'+ total_itens+'" onClick="excluirCampo('+ total_itens+');"></center> '
				 + '<input type="hidden" name="acao_linha_'+ total_itens+'" id="acao_linha_'+ total_itens+'" value="I" >';

    addRowDOM('tbl_campos_param', coluna_1, coluna_2, coluna_3, coluna_4);

} 

 function formataPorcentagem()
    {
        var valor;

        valor = parseInt(document.getElementById('val_confianca_min').value);

		if (valor >= 100) document.getElementById('val_confianca_min').value = '100';
    }

function verificaNumero(evt)
    {
        var evt = evt || window.event; // event object
        var keyCode = evt.keyCode ? evt.keyCode : evt.which ? evt.which : evt.charCode;
        if (keyCode > '34' && keyCode < '41')
        {		
            if (bowser.msie && parseInt(bowser.version) <= 10.0)
            {
                evt.returnValue = false;
            }
            else
            {
                evt.preventDefault();
            }
        }
    }

function formataConfianca(linha)
    {
        var valor;

        valor = parseInt(document.getElementById('val_confianca_'+linha).value);

		if (valor >= 100) document.getElementById('val_confianca_'+linha).value = '100';
		
    }

//-------------------------------------------------------------------------------------------

</script>
