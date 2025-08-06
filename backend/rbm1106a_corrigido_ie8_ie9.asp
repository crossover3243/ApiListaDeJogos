<%@ LANGUAGE="VBSCRIPT" %>
<%
'-----------------------------------------------------------
'-	Tipos de Anexo Prévia
'-	Criação : 13/01/2025 por Erick Prado
'-----------------------------------------------------------    

option explicit

Dim sUsuario, sSenha, sIP, sModulo, sSistema, txt_msg, txt_pgm_retorno, txt_subtitulo
dim rsPesquisa, nom_tipo_anexo,  cod_tipo_anexo, tempoIni, ind_acao, ind_abrangencia, ind_aplicacao
dim cod_tipo_reembolso, rsCombo, ind_debug
dim dt_atual, ind_tipo_validacao
dim ind_canais_digitais, ind_anexo_obrigatorio, ind_tipo_submodalidade             



Dim vet_PL(), txt_mensagem
dim pCampoAtual, ind_tipo_reembolso, vet_PL2(2,4)
Redim vet_PL(0, 0)


dim sDisplayConsulta,sDisplayExame,sDisplayInternacao
dim qtd_faixa_consulta, qtd_faixa_exame, qtd_faixa_internacao, qtd_ocorrencia
dim fl_permite_download, sWhereAtendimento, sDesabilita, sDisabled, txt_disabled
    
tempoIni = Timer

sUsuario	= Session("ace_usuario")
sSenha		= Session("ace_senha")
sIP			= Session("ace_ip")
sModulo		= Session("ace_modulo")
sSistema	= session("ace_sistema")

txt_msg			= Session("txt_msg")
txt_subtitulo	= Request.QueryString("PT")
txt_mensagem    = Request("txt_mensagem")
	
Session("txt_msg") = ""
session("pgm_retorno") = Request.ServerVariables("SCRIPT_NAME") & "?pt=" & txt_subtitulo


txt_pgm_retorno 	= session("pgm_retorno")
ind_debug  			= "S"

sDisplayConsulta	= "none"
sDisplayExame		= "none"
sDisplayInternacao	= "none"


%>
<!--Include do recordset oracle-->
<!--#include file=..\..\gen\asp\gen0146a.asp-->
<!--#include file=..\..\gen\asp\gen0146b.asp-->

<%
cod_tipo_anexo = Request("cod_tipo_anexo")
ind_acao       = Request("ind_acao")

Dim sHtmlModalidades
sHtmlModalidades = ""
Dim linhaIndex
linhaIndex = 1
Dim sScriptSubmodalidades
sScriptSubmodalidades = ""

if trim(cod_tipo_anexo) <> "" then

    '--------------------------
    'Recupera tipo de anexo
    '--------------------------
    Redim vet_PL(1, 4)
    vet_PL(1, 1) = "IN"
    vet_PL(1, 2) = "adDouble"
    vet_PL(1, 3) = "p_cod_tipo_anexo"
    vet_PL(1, 4) = cod_tipo_anexo

    Set rsPesquisa = rsCursorOracle(CStr(sUsuario), _
                                     CStr(sSenha), _
                                     CStr(sIP), _
                                     CStr(sSistema), _
                                     CStr(sModulo), _
                                     "TS.RBM_MANTER_TIPO_ANEXO_PREVIA.ObterTipoAnexo", _
                                     vet_PL, _
                                     false)

    if rsPesquisa.eof then
        ind_acao = "I"
        fl_permite_download = "N"
    else
        ind_acao = "A"

        ' Pega os dados fixos da primeira linha
        cod_tipo_anexo        = rsPesquisa("COD_TIPO_ANEXO")
        nom_tipo_anexo        = rsPesquisa("NOM_TIPO_ANEXO")
        fl_permite_download   = rsPesquisa("FL_PERMITE_DOWNLOAD")
        ind_canais_digitais   = rsPesquisa("IND_CANAIS_DIGITAIS")
        ind_anexo_obrigatorio = rsPesquisa("IND_ANEXO_OBRIGATORIO")
        txt_mensagem          = rsPesquisa("TXT_JUSTIFICATIVA")	
	
		' Monta as linhas de modalidade/submodalidade com nomes únicos
		Do While Not rsPesquisa.EOF
    If Not IsNull(rsPesquisa("IND_TIPO_REEMBOLSO")) And Trim(rsPesquisa("IND_TIPO_REEMBOLSO")) <> "" Then
        ind_tipo_reembolso     = rsPesquisa("IND_TIPO_REEMBOLSO")
        ind_tipo_submodalidade = rsPesquisa("IND_TIPO_SUBMODALIDADE")

        sHtmlModalidades = sHtmlModalidades & "<tr>"
        sHtmlModalidades = sHtmlModalidades & "<td class='label_right'>Modalidade:&nbsp;</td>"
        sHtmlModalidades = sHtmlModalidades & "<td>"
        sHtmlModalidades = sHtmlModalidades & montaCombo( _
            retornaCursor("tipo_reembolso", "ind_tipo_reembolso", "nome_tipo_reembolso", "", "order by ind_tipo_reembolso"), _
            "ind_tipo_reembolso_" & linhaIndex, _
            ind_tipo_reembolso, _
            "atualizaModalidade(this.value, 'ind_tipo_submodalidade_" & linhaIndex & "', '" & ind_tipo_submodalidade & "')", _
            "" _
        )
        sHtmlModalidades = sHtmlModalidades & "</td>"

        If Not IsNull(ind_tipo_submodalidade) And Trim(ind_tipo_submodalidade) <> "" Then
            sHtmlModalidades = sHtmlModalidades & "<td class='label_right'>Submodalidade:&nbsp;</td>"
            sHtmlModalidades = sHtmlModalidades & "<td><select name='ind_tipo_submodalidade_" & linhaIndex & "' id='ind_tipo_submodalidade_" & linhaIndex & "'></select></td>"

            ' Gera script para carregar e selecionar submodalidade
            sScriptSubmodalidades = sScriptSubmodalidades & "carregaSubModalidade('" & ind_tipo_reembolso & "', 'ind_tipo_submodalidade_" & linhaIndex & "', '" & ind_tipo_submodalidade & "');" & vbCrLf
        End If

        sHtmlModalidades = sHtmlModalidades & "</tr>"

        linhaIndex = linhaIndex + 1
    End If
    rsPesquisa.MoveNext
Loop


		' Tratamento visual
		if fl_permite_download = "1" then
			sDesabilita = "readonly class=camposblocks"
			sDisabled   = "S"
			fl_permite_download = "S"
		else
			sDesabilita = ""
			sDisabled   = ""
			fl_permite_download = "N"
		end if
    end if
end if
%>


<!--#include file=..\..\gen\inc\inc0000.asp-->
<!--#include file=..\..\gen\inc\inc0001.asp-->
<!--#include file=..\..\gen\inc\inc0002.asp-->

<!DOCTYPE html>
<HTML>
<HEAD>
<meta http-equiv="X-UA-Compatible" content="IE=9" />
<title><%=Application("app")%></title>

<link href="\gen\css\css002.css" rel="stylesheet" type="text/css">
<link id="luna-tab-style-sheet" href="\gen\css\tab2.css" rel="stylesheet" type="text/css">

<script type="text/javascript" src="\gen\js\tabpane.js"></script>
<script type="text/javascript" src="\gen\js\cpaint2.inc.compressed.js"></script>

<!-- CALENDARIO INICIO -->
<link rel="stylesheet" type="text/css" media="all" href="/gen/css/calendar-green.css" title="green" />
<script type="text/javascript" src="/gen/js/calendar.js"></script>
<script type="text/javascript" src="/gen/js/calendar-br.js"></script>
<script type="text/javascript" src="/gen/js/calendar-setup.js"></script>
<!-- CALENDARIO FIM -->

</head>

<script type="text/javascript" src="../../gen/modal/modal.crossbrowser.min.js"></script>
<script src="\gen\js\waitbar.js" type="text/javascript"></script>

<!-- Contem as fun??es javascript para a regra de autoriza??o -->


<script language="javascript">

    var _ind_tipo_validacao = "<%=ind_tipo_validacao%>";

    var gLinha;
	
	var contadorModSubmod = 1; 
	
	function MascOBS()
	{
		//NAO DEIXA DIGITAR '
		if ((window.event || event).keyCode == '39')
			(window.event || event).returnValue = false;
	}

	//Função para retornar o objeto document do frame
    function iframeRef( frameRef ) {
        return frameRef.contentWindow ? frameRef.contentWindow.document : frameRef.contentDocument
    }

    function acao_voltar() {
        MostrarWait();
        document.form01.cod_tipo_anexo.value = "";
		form01.ind_acao.value = "";
        document.form01.action = "rbm1106a.asp?PT=" + form01.txt_subtitulo.value;
        document.form01.submit();
    }
    //-------------------------------------------------------------------------------------------
    function reexecute() {
        MostrarWait();
        document.form01.action = form01.txt_pgm_retorno.value;
        document.form01.submit();
    }
    //-------------------------------------------------------------------------------------------
    function acao_continuar() {
        MostrarWait();
        reexecute();
    }
    //-------------------------------------------------------------------------------------------
    function acao_incluir() {
        if (!validacao())
            return false;

        MostrarWait();
		
		form01.ind_acao.value = 'I';
        form01.action = "rbm1106b.asp?ind_executando=S";
        form01.submit();
    }
    //-------------------------------------------------------------------------------------------
    function acao_alterar() {
        if (!validacao())
            return false;
        MostrarWait();
        form01.ind_acao.value = 'A';
        form01.action = "rbm1106b.asp?ind_executando=S";
        form01.submit();
    }
    //-------------------------------------------------------------------------------------------
    function acao_excluir() {
        if (confirm("Confirma exclusão?") =) {
            MostrarWait();
            form01.ind_acao.value = 'E';
            form01.action = "rbm1106b.asp?ind_executando=S";
            form01.submit();
        }
    }
    //-------------------------------------------------------------------------------------------
    function validacao() {
	
		if (form01.nom_tipo_anexo.value == '') {
            alert('Descrição do Tipo de Anexo é obrigatória.')
            form01.nom_tipo_anexo.focus();
            return false;
        }
		
		
		//if (document.getElementById('tdSubmodalidade').style.display == ""){
		//	if (document.getElementById('ind_tipo_reembolso').value == "" && document.getElementById('ind_tipo_submodalidade').value != ""){		
		//		alert('Não é possível salvar modalidade em branco ao escolher uma submodalidade.');
		//		return false;
		//	}
		//}
		
		if (form01.ind_canais_digitais[0].checked =){

		   if (document.getElementById('ind_tipo_reembolso').value == ""){
				alert('Obrigatório informar a modalidade para canais digitais.');
				return false;
			}
		} 
		return true;
    }
	
    function CarregarNovoTipoAnexo() {

        MostrarWait();
		
		var cp = new cpaint();
        cp.set_transfer_mode('get');
        cp.set_debug(false);
        cp.set_response_type('text');
        cp.set_async(false); //Faz com que espere o termino deste processo para continuar com o restante do código
        cp.call('../../rbm/asp/rbm1106c.asp', 'RetornarNovoCodTipoAnexo', ExibirNovoCodTipoAnexo);
    }
    //-------------------------------------------------------------------------------------------
    function ExibirNovoCodTipoAnexo(pNovoCodigo) {
		
       
		if( pNovoCodigo.length > 4 ) {
			alert("Tamanho do código retornado pela sequence é muito grande.");
			return false;
		}

        form01.cod_tipo_anexo.value = pNovoCodigo;
		
        reexecute();
    }
    
    function AbrePesquisaTipoAnexo() {

        var sChamada = '';
        sChamada += '/ACE/ASP/ACE0090a.asp';
        sChamada += '?nomcampo=NOM_TIPO_ANEXO';
        sChamada += '&indsubmit=True';
        sChamada += '&codcampo=COD_TIPO_ANEXO';
		sChamada += '&indTela=rbm1106a';
        sChamada += '&PesqNome=img_pesquisa';
        sChamada += '&codcampodisplay=cod_tipo_anexo';
        sChamada += '&tabela=ts.rbm_tipo_anexo_previa';
        sChamada += '&titulopesquisa=Pesquisar Tipo de Anexo';

        AbrePesquisa(sChamada, 'img_pesquisa', 'Pesquisar Tipo de Anexo', '700', '600', '', '', 'S')
    }
		
	function ValidaIntLocal() {

        form01.cod_tipo_anexo.value = Trim(form01.cod_tipo_anexo.value);

        ValidaInt();

        if (form01.cod_tipo_anexo.value != "")
            reexecute();
    }
//---------------------------------------------------------------------------------
function atualizaModalidade(pValor) {
    var tipo;
    var idSubmodalidade;
	var exibirMensagem;

    if (typeof pValor === "object" && pValor !== null && pValor.value !== undefined) {
        tipo = pValor.value;
        var idCombo = pValor.id;
        var numero = idCombo.split("_").pop();
		
		if(numero == "reembolso"){
			idSubmodalidade = "ind_tipo_submodalidade";
		}
		else{
			idSubmodalidade = "ind_tipo_submodalidade_" + numero;
		}		
        
    } else {
        tipo = pValor;
        idSubmodalidade = "ind_tipo_submodalidade";
		exibirMensagem = false;
		
    }

    carregaSubModalidade(tipo, idSubmodalidade, "999", exibirMensagem);
}
//--------------------------------------------------------------------------------------------
function carregaSubModalidade(tipo, idDestino, valorSelecionado, exibirMensagem ) {
    if (!idDestino) {
        idDestino = "ind_tipo_submodalidade";
    }

    var tdSub = document.getElementById(idDestino);

    if (tipo == "" || !tdSub) {
        var txtMsg = document.getElementById('txt_msg');
        var tdSubmodalidade = document.getElementById('tdSubmodalidade');
        var lbSubmodalidade = document.getElementById('lbSubmodalidade');

        if (idDestino === "ind_tipo_submodalidade") {
            if (txtMsg) txtMsg.style.display = '';
            if (tdSubmodalidade) tdSubmodalidade.style.display = 'none';
            if (lbSubmodalidade) lbSubmodalidade.style.display = 'none';
        }

        if (tdSub) tdSub.innerHTML = "<option></option>";
        return false;
    }

    var cp = new cpaint();
    cp.set_transfer_mode('get');
    cp.set_response_type('text');
    cp.set_debug(false);
    cp.set_async(false);

    cp.call('../../rbm/asp/rbm0079f.asp', 'carregaSubModalidadePersonalizada', function(pDescricao) {
        ExibeSubmodalidade(pDescricao, idDestino, exibirMensagem);

        // Seleciona o valor após carregar
        if (valorSelecionado) {
            var select = document.getElementById(idDestino);
            if (select) {
                for (var i = 0; i < select.options.length; i++) {
                    if (select.options[i].value == valorSelecionado) {
                        select.options[i].selected = true;
                        break;
                    }
                }
            }
        }
    }, tipo, "", "S", idDestino);
}
//------------------------------------------------------------------
function ExibeSubmodalidade(pDescricao, idDestino, exibirMensagem ) {
    if (!idDestino) {
        idDestino = "ind_tipo_submodalidade";
    }

    var tdSub = document.getElementById(idDestino);

    // Extrai o número do ID (ex: ind_tipo_submodalidade_2 ? 2)
    var numero = idDestino.split("_").pop();

    var txtMsg, tdSubmodalidade, lbSubmodalidade;

    if (numero == "submodalidade") {
        txtMsg = document.getElementById('txt_msg');
        tdSubmodalidade = document.getElementById('tdSubmodalidade');
        lbSubmodalidade = document.getElementById('lbSubmodalidade');
    } else {
        txtMsg = document.getElementById("txt_msg_" + numero);
        tdSubmodalidade = document.getElementById("tdSubmodalidade_" + numero);
        lbSubmodalidade = document.getElementById("lbSubmodalidade_" + numero);
    }

    if (pDescricao == "-1") {
        if (exibirMensagem && txtMsg) txtMsg.innerHTML = "Não existe submodalidade para modalidade selecionada!";
        if (exibirMensagem && txtMsg) txtMsg.style.display = '';
        if (tdSubmodalidade) tdSubmodalidade.style.display = 'none';
        if (lbSubmodalidade) lbSubmodalidade.style.display = 'none';

        if (tdSub) tdSub.innerHTML = "<option></option>";
    } else {
        if (txtMsg) txtMsg.style.display = 'none';
        if (tdSubmodalidade) tdSubmodalidade.style.display = '';
        if (lbSubmodalidade) lbSubmodalidade.style.display = '';

        if (tdSub) tdSub.innerHTML = pDescricao;
    }
}
//-----------------------------------------
function adicionarLinhaModSubmod() {
    var tbody = document.getElementById("tbodyModalidade");
    var novaLinha = document.createElement("tr");

    // Clona o combo modelo
    var comboHTML = document.getElementById("comboModelo").innerHTML;

    // Garante que o ID e name sejam únicos
    var idReembolso, idSubmodalidade;
    do {
        idReembolso = "ind_tipo_reembolso_" + contadorModSubmod;
        idSubmodalidade = "ind_tipo_submodalidade_" + contadorModSubmod;
        contadorModSubmod++;
    } while (document.getElementById(idReembolso) || document.getElementById(idSubmodalidade));

	contadorModSubmod--;
    // Atualiza o nome e id do combo para serem únicos
    var comboAtualizado = comboHTML
        .replace(/name="ind_tipo_reembolso"/g, 'name="' + idReembolso + '"')
        .replace(/id="ind_tipo_reembolso"/g, 'id="' + idReembolso + '"');

    var htmlLinha = ""
        + "<td class=\"label_right\">Modalidade:&nbsp;</td>"
        + "<td>" + comboAtualizado + "</td>"
        + "<td class=\"label_right\" id=\"lbSubmodalidade_" + contadorModSubmod + "\" style=\"display: none;\">Submodalidade:&nbsp;</td>"
        + "<td id=\"tdSubmodalidade_" + contadorModSubmod + "\" style=\"display: none;\">"
        + "<select name=\"" + idSubmodalidade + "\" id=\"" + idSubmodalidade + "\" tabindex=\"0\">"
        + "<option></option>"
        + "</select>"
        + "</td>"
        + "<td></td>";

    novaLinha.innerHTML = htmlLinha;

    // Insere antes da última linha (que contém o botão)
    var linhas = tbody.getElementsByTagName('tr');
    var ultimaLinha = linhas[linhas.length - 1];
    tbody.insertBefore(novaLinha, ultimaLinha);
}
</script>

<BODY>

<%AbreTable()%>
<font class="subtitulos"><%=txt_subtitulo%></font>
<%FechaTable()%>

<%Call SetWaitBar()%>

<div id="txt_msg" class="msg" align="center"><%=txt_msg%></div>

<form method="POST" name="form01">

<%AbreTable()%>

<table border="0" max-width="100%" align="center">
    <tr>
        <td width="15%" nowrap class="label_right">Código&nbsp;</td>
        <td nowrap >
            <input type="text" name="cod_tipo_anexo" value="<%=cod_tipo_anexo%>" size="4" maxlength="4" OnKeyDown="TeclaEnter();" <% if trim(ind_acao) <> "" then Response.Write "Readonly class=camposblocks" %>  onKeyPress ="javascript:MascInt()" OnChange="javascript:ValidaIntLocal();">
            <%if trim(cod_tipo_anexo) = "" then %>
                <img style='cursor:hand' name='img_pesquisa' width='16' height='16' src='/gen/mid/lupa.gif' border='0' alt='Pesquisar Tipos de Anexo' onClick="AbrePesquisaTipoAnexo();" >
	            <input type="button" name="btnNovoTipoAnexo" value="Novo Tipo de Anexo" onClick="CarregarNovoTipoAnexo();" style="cursor:hand" tabindex="1">
            <%end if%>
        </td>
    </tr>
    <tr>
        <td class="label_right">Descrição&nbsp;</td>
        <td class="label_left" nowrap>
            <input type="text" name="nom_tipo_anexo" value='<%=replace(nom_tipo_anexo,"'","""")%>'  size="60" maxlength="60" tabindex="1" <% if trim(ind_acao) = "" then Response.Write "Readonly class=camposblocks" %>>
        </td>
    </tr>
	<%=sHtmlModalidades%>	
	<tbody id="tbodyModalidade">
		<tr>
			<% If linhaIndex = 1 Then %>
				<td class="label_right">Modalidade:&nbsp;</td>
				<td>
					<%
					set rsCombo = retornaCursor("tipo_reembolso","ind_tipo_reembolso","nome_tipo_reembolso","", "order by ind_tipo_reembolso") 
					response.write montaCombo(rsCombo, "ind_tipo_reembolso", ind_tipo_reembolso, "atualizaModalidade(this)", "")
					%>    
				</td>
				<td id="lbSubmodalidade" style="display: none;" class="label_right">Submodalidade:&nbsp;</td>
				<td id="tdSubmodalidade" style="display: none;">    
					<select name="ind_tipo_submodalidade" id="ind_tipo_submodalidade" tabindex="0">
						<option></option>
					</select>
				</td>
			<% End If %>			
			<td>
				<button type="button" onclick="adicionarLinhaModSubmod()">+ Adicionar</button>
			</td>
		</tr>
	</tbody>	
	<tr>
		<td width="15%" class="label_right">Mostrar nos Canais Digitais:&nbsp;</td>
		<td class="label_left">
			<input type="radio" name="ind_canais_digitais" value="S" tabindex="0" <%if ind_canais_digitais = "S" then%> checked <%end if%> onclick="atualizaAnexoObrigatorio('S');"/>&nbsp;Sim
			&nbsp;&nbsp;<input type="radio" name="ind_canais_digitais" value="N"  tabindex="0" <%if ind_canais_digitais = "N" or ind_canais_digitais = "" then%> checked <%end if%> onclick="atualizaAnexoObrigatorio('N');"/>&nbsp;Não  
		</td>
	</tr>
	<tr>
		<td width="15%" class="label_right">Tipo de Anexo obrigatório:&nbsp;</td>
		<td class="label_left">
			<input type="radio" name="ind_anexo_obrigatorio" value="S" tabindex="0" <%if ind_anexo_obrigatorio = "S" then%> checked <%end if%> onclick="atualizaAnexoObrigatorio('S');"/>&nbsp;Sim
			&nbsp;&nbsp;<input type="radio" name="ind_anexo_obrigatorio" value="N"  tabindex="0" <%if ind_anexo_obrigatorio = "N" or ind_anexo_obrigatorio = "" then%> checked <%end if%>/>&nbsp;Não  
		</td>
	</tr>
	<tr>
	    <td class="label_right">Justificativa:&nbsp;</td>
		<td>
			<textarea name="txt_mensagem" rows="8" cols="80" tabindex="1" onKeyUp="ContarTexto(this, 1000, 'qtd_caracteres')" onKeyPress="MascOBS();"><%=txt_mensagem%></textarea>
			<div id="qtd_caracteres" class="label_left"><%=1000 - Cint(Len(txt_mensagem & "")) %> caracteres restantes</div>
		</td>
	</tr>
</table>
<%FechaTable()%>


<input type="hidden" name="txt_pgm_retorno" value="<%=txt_pgm_retorno%>">
<input type="hidden" name="ind_acao" value="<%=ind_acao%>">
<input type="hidden" name="cod_usuario" value="<%=sUsuario %>" />
<input type="hidden" name="txt_subtitulo" value="<%=txt_subtitulo %>" />
<input type="hidden" name="txt_xml_funcao_temp" id="txt_xml_funcao_temp" value=""> 
<input type="hidden" name="fl_permite_download" value="<%=fl_permite_download%>">

<iframe WIDTH"0" HEIGHT="0" name="if_execucao" id="if_execucao" src="" frameBorder="yes"></iframe>


</form>

<script type="text/javascript">
	<% if trim(ind_acao)<>"" then %>
		document.form01.nom_tipo_anexo.focus();
	<% else %>
		document.form01.cod_tipo_anexo.focus();
	<% end if %>
	
</script>
<%
'VOLTAR/CONTINUAR/LIMPAR/INCLUIR/ALTERAR/EXCLUIR/EXECUTAR

select case trim(ind_acao)
    case "I":
        call MontaToolbar("S","N","S","S","N","N","N","N")        
    case "A"
        call MontaToolbar("S","N","S","N","S","S","N","N")
    case "N"
        call MontaToolbar("N","S","S","N","N","N","N","N")
	case else
		call MontaToolbar("S","N","S","N","N","N","N","N")
end select  

'------------------------------------------------------------------------------------------
function montaCombo(rsCombo, nome, valor, onChange, disabled)
    
    dim strCombo, txt_disabled
    
    if disabled = "S" then
        txt_disabled = "readonly='readonly' class='camposblocks' disabled"
    else
        txt_disabled = disabled
    end if
    
    strCombo = ""
    
    strCombo = "<select id='" & nome & "' name='" & nome & "' onchange='" & onChange & "' tabindex='0' " & txt_disabled & ">"
    strCombo = strCombo & "<option></option>" & Chr(13) & Chr(10)
    
    do while not rsCombo.eof 
        dim val1, val2
        if IsNull(valor) then
            val1 = ""
        else
            val1 = CStr(valor)
        end if

        if IsNull(rsCombo(0)) then
            val2 = ""
        else
            val2 = CStr(rsCombo(0))
        end if

        if val1 = val2 then
            strCombo = strCombo & "<option value='" & rsCombo(0) & "' selected>" & rsCombo(1) & "</option>" & Chr(13) & Chr(10)        
        else
            strCombo = strCombo & "<option value='" & rsCombo(0) & "'>" & rsCombo(1) & "</option>" & Chr(13) & Chr(10)
        end if
        rsCombo.movenext
    loop

    strCombo = strCombo & "</select>" & Chr(13) & Chr(10)
    montaCombo = strCombo
end function
'------------------------------------------------------------------------------------------
function retornaCursor(p_nome_tabela, p_campo_value, p_campo_desc, p_where, p_order)
	'-----------------------------------------------------------------------
	'Montar combo da situação dos reembolsos
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

	Set rsCombo =  rsCursorOracle (	CStr(Session("ace_usuario")),_
									CStr(Session("ace_senha")),_
									CStr(Session("ace_ip")),_
									CStr(Session("ace_sistema")),_
									CStr(Session("ace_modulo")),_
									"RB_REEMBOLSO.RetornaCursor", _
									VetCombo, _
									false )
	


	set retornaCursor = rsCombo			
end function      
%>

<!--Colocar o tempo de execução da página-->
<table width=100%>  
    <tr><td align=right style="COLOR:#000080;FONT-FAMILY:Arial;FONT-SIZE:11px;">Tempo de execução da página : <b><%=round(timer - tempoIni,2) & "s"%></b></td></tr>
</table> 

<div id="comboModelo" style="display:none;">
    <%
    set rsCombo = retornaCursor("tipo_reembolso","ind_tipo_reembolso","nome_tipo_reembolso","", "order by ind_tipo_reembolso") 
    response.write montaCombo(rsCombo, "ind_tipo_reembolso", "", "atualizaModalidade(this)", "")
    %>
</div>
 
<script type="text/javascript">
<%=sScriptSubmodalidades%>
</script>


<script type="text/javascript">window.onload = function () { atualizaModalidade("<%=ind_tipo_reembolso%>"); };</script>
</BODY>
</HTML>
<%
FechaConexao()
%>