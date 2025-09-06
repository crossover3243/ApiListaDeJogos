<%@ LANGUAGE="VBSCRIPT" %>
<%
    dim txt_usuario, txt_senha, txt_ip, txt_modulo, txt_sistema, num_tabindex
    dim num_pedido, txt_msg, txt_subtitulo, xml_autorizacao, ind_leitura, rsCompetencia, cod_leitura_doc

	txt_usuario     = Session("ace_usuario")
    txt_senha       = Session("ace_senha")
    txt_ip          = Session("ace_ip")
    txt_modulo      = Session("ace_modulo")
    txt_sistema     = Session("ace_sistema")
    txt_msg         = Session("txt_msg")
    txt_subtitulo   = Request.QueryString("PT")
    num_pedido      = Request("num_pedido")
	ind_leitura     = Request("ind_leitura")
	cod_prestador   = Request("cod_prestador")
	cod_prestador_ts= Request("cod_prestador_ts")
	nome_prestador  = Request("nome_prestador")

	Session("txt_msg")     = ""
    session("pgm_retorno") = Request.ServerVariables("SCRIPT_NAME") & "?pt=" & txt_subtitulo
%>

<!--#include file=..\..\gen\asp\gen0202a.asp-->
<!--#include file=..\..\gen\inc\inc0000.asp-->
<!--#include file=..\..\gen\inc\inc0001.asp-->
<!--#include file=..\..\gen\inc\inc0002.asp-->
<!--#include file=../../gen/asp/gen0146a.asp-->
<!--#include file=../../gen/asp/gen0146b.asp-->
<!--#include file=../../atd/asp/atd0027q.asp-->
<!--INCLUDE DE VERIFICAÇÃO EXTENSÃO ARQUIVO-->
<!--#include file=..\..\gen\asp\gen0301a.asp-->

<%if trim(num_pedido) <> "" then %>
    <form enctype="multipart/form-data" method="post" name="form01" id="form01">
<%else%>
    <form method="post" name="form01" id="form01">
<%end if%>

<%
	'Monta as Pesquisas
	redim vet_PL(2,4)
	vet_PL(1, 1) = "IN"
	vet_PL(1, 2) = "adLongVarChar"
	vet_PL(1, 3) = "p_xml_parametros"
	vet_PL(2, 1) = "IN"
	vet_PL(2, 2) = "adVarChar"
	vet_PL(2, 3) = "p_ctr_logs"

	call rsPesquisaGenerica(vet_PL, rsCompetencia, "ctm_rcs_telas_relatorios.get_ctrlComp_iRemessa_nao_e", false)
	
	'Pesquisa de Filial e Operadora
	redim vet_PL(3,4)
	vet_PL(1, 1) = "OUT"
	vet_PL(1, 2) = "adVarChar"
	vet_PL(1, 3) = "p_cod_retorno"
	vet_PL(2, 1) = "OUT"
	vet_PL(2, 2) = "adVarChar"
	vet_PL(2, 3) = "p_msg_retorno"
	vet_PL(3, 1) = "IN"
	vet_PL(3, 2) = "adVarChar"
	vet_PL(3, 3) = "p_cod_usuario"
	vet_PL(3, 4) = txt_usuario

	num_tabindex = 0
%>

    <html>
        <head>
            <link href="/gen/css/css002.css?contexto=<%=session("contexto")%>" rel="stylesheet" type="text/css">
            <script type="text/javascript" src="/gen/js/waitbar.js"></script>
            <script src="../../gen/js/gen0202.js" type="text/javascript"></script>
            <script type="text/javascript" src="\gen\js\cpaint2.inc.compressed.js"></script>
        </head>

        <%AbreTable()%>
            <font class="subtitulos"><%=txt_subtitulo%></font>
        <%FechaTable()%>

        <body>
            <div id="txt_msg" class="msg" align="center"><%=txt_msg%></div>
            <td colspan="4" class="label_left">
                <fieldset class="label_left">
                    <legend class="label_left">Autorização</legend>
                    <table id="busca_num_pedido">
                        <tr>
                            <td class="label_right"><span style="margin-left:37px">Nº Pedido:</span>&nbsp;</td>
                            <td>
                                <input type='text' name='num_pedido' id='num_pedido' value='<%=num_pedido%>' size='15' maxlength='25' tabindex='1' onKeyPress='javascript:MascInt()' OnKeyDown='TeclaEnter();' onChange='javascript:this.value=Trim(this.value);ValidaInt(event);reexecute();'>&nbsp;
                                <img id='Pesquisa_Pedido' style='cursor:pointer;cursor:hand' name='Pesquisa_Pedido' id='Pesquisa_Pedido' width='16' height='16' src='/gen/mid/lupa.gif' border='0' title='Pesquisar Pedido de Autorização' onClick="javascript:ValidaPesquisa('/GEN/ASP/GEN0071a.asp?ind_forma_abertura=&ind_forma_abertura&indsubmit=True&nome_campo_cod=num_pedido&abre_modal=N&vOpera=S &funcao_executar=', 'Pesquisa_Pedido', 'Pesquisar Pedido de Autorização', 900, 500, 20, 15, 'N')">
                            </td>
                        </tr>
                    </table>
                </fieldset>
                <td width='15%' class='label_right'>&nbsp;</td>
                <td colspan="4" class="label_left">
                    <fieldset class="label_left">
                        <legend class="label_left">Contas Médicas</legend>
                        <table id="busca_nr">	
                            <tr>
                                <td width='15%' class='label_right'>&nbsp;</td>
                                <td>
                                    <%
                                    'Monta combos de data passando o nome do campo retornado da query
                                    call MontaComboData(rsCompetencia, "comboNR()", "mes")
                                    %>
                                </td>
                            </tr>
                            <tr>
                                <td width='15%' class='label_right'>Prestador:&nbsp;</td>
                                <td class="label_left">
                                    <input type="text" name="cod_prestador" id="cod_prestador" value="<%=cod_prestador%>" size="12" maxlength="11" onKeyPress="MascInt();" OnKeyDown="TeclaEnter();" onChange="ValidaInt();CarregaPrestador();"/>
                                    <img width="16" height="16" style="cursor: hand;" onclick="javascript:AbrePesquisa('/GEN/ASP/GEN0005a.asp?indsubmit=&nome_campo_cod_ts=&nome_campo_cod=&nome_campo_desc=&prestador_provedor=&txt_where_aux=&ind_tipo_pessoa_fixo=&abre_modal=S&cod_tipo_usuario=&cod_identificacao_ts=&nome_funcao_jsp=CarregaPrestador();', 'Pesquisa_Prestador', 'Pesquisa Prestador', 850, 500, 20, 15, 'S')" alt="Pesquisa Prestador" src="/gen/mid/lupa.gif" border="0" complete="complete"/>
                                    <input type="text" readonly class=camposblocks name="nome_prestador" value="<%=nome_prestador%>" size="44"/>
                                    <input type="hidden" name="cod_prestador_ts" value="<%=cod_prestador_ts%>"/>
                                </td>               
                            </tr>
                            <tr>
                                <td class="label_right" width="20%">NR:&nbsp;</td>
                                <td class="label_left" id="td_select_nr">
                                    <div id="dv_nr">
                                        <select name="p_cod_nr" id="p_cod_nr">
                                            <option value=''></option>
                                        </select>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td class="label_right" width="20%">Conta/Guia:&nbsp;</td>
                                <td class="label_left" id="td_select_conta">
                                    <div id="dv_conta">
                                        <select name="cod_ts_conta" id="cod_ts_conta"></select>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </fieldset>
                </td>
            </td>
            <tr width='15%' class='label_right'>&nbsp;</tr>
            <%
            if num_pedido <> "" then
                call exibeGrid()
                ind_leitura = "S"
                %>
                <script>
                    document.getElementById("cod_prestador_ts").value = "";
                    document.getElementById("cod_prestador").value = "";
                    document.getElementById("nome_prestador").value = "";
                </script>
                <%
            end if	
            call MontaDadosAnexoContas()
            %>
        </body>

        <script>

            function ValidaPesquisa(pQueryString, pNomeIdPesquisa, pNomePesquisa, pPopupWidth, pPopupHeight, pPopupTop, pPopupLeft, pAbreModal) {
                if (form01.num_pedido.value != "") {
                    alert("Nº do pedido já preenchido. Para pesquisar, deve-se limpar o nº do pedido.");
                    return false;
                }

                AbrePesquisa(pQueryString,pNomeIdPesquisa, pNomePesquisa, pPopupWidth, pPopupHeight, pPopupTop, pPopupLeft, pAbreModal);
            }

            function reexecute() {
                document.form01.action = '<%=session("pgm_retorno")%>';
                document.form01.submit();
            }

            function acao_continuar() {
                if (form01.num_pedido.value != "") {
                    reexecute();
                }
            }

            function mostra_detalhe(detalhe) {
                janela = window.open('','teste','location=no,menubar=no,directories=no,resizable=no,scrollbars=no,status=no,toolbar=no,width=400,height=300');
                janela.document.write('<textarea readonly cols=43 rows=16 name="txt_descricao" id="txt_descricao">');
                janela.document.write(detalhe);
                janela.document.write('</textarea>');
            }

            function CarregaPrestador() {
                var num_pedido = document.getElementById("num_pedido").value;
                if (num_pedido) {
                    alert("Limpe os dados de Autorização para pesquisar por Contas Médicas.");
                    if (form01.cod_prestador.value) {
                        form01.p_mes_ano_ref.value = "";
                        form01.cod_prestador.value = "";
                    }
                    return false;
                }

                if (!form01.cod_prestador) {
                    return false;
                }  
                if (form01.cod_prestador.value == "") {
                    acao_limpar();
                    return false;
                }

                var cp = new cpaint();
                cp.set_transfer_mode('get');
                cp.set_debug(false);
                cp.call('../../ctm/asp/ctm2004b.asp', 'CarregaPrestador', ExibePrestador, form01.cod_prestador.value);
                cp = null;
            }

            function ExibePrestador(pXML) {
                if (pXML == "" || pXML == null) {
                    document.getElementById('txt_msg').innerHTML = "Prestador não encontrado";
                    document.getElementById('txt_msg').display = "";
                    form01.nome_prestador.value = "";
                    form01.cod_prestador_ts.value = "";
                    form01.cod_prestador.value = "";
                    return false;
                }

                var tabela = pXML.ajaxResponse[0].find_item_by_id('resultado', 'tabela');

                if (tabela.eof[0].data=="S") {
                    document.getElementById('txt_msg').innerHTML = "Prestador não encontrado";
                    document.getElementById('txt_msg').display = "none";
                    form01.nome_prestador.value = "";
                    form01.cod_prestador_ts.value = "";
                    form01.cod_prestador.value = "";
                } else {
                    form01.cod_prestador_ts.value = tabela.codPrestadorTs[0].data;
                    form01.nome_prestador.value = tabela.nomePrestador[0].data;
                    comboNR();
                }

                tabela = null;
            }

            function comboNR() {
                var cod_prestador_ts = document.getElementById("cod_prestador_ts").value;
                var mes_ano_ref = document.getElementById("p_mes_ano_ref").value;
                VerificaNR(cod_prestador_ts, mes_ano_ref);
            }

            function VerificaNR(cod_prestador_ts, mes_ano_ref) {
                var cp = new cpaint();
                cp.set_transfer_mode('get');
                cp.set_response_type('text');
                cp.set_debug(false);
                cp.set_async(false); //Faz com que espere o término deste processo para continuar com o restante do código	
                if (mes_ano_ref != '' && cod_prestador_ts != '') {
                    var num_pedido = document.getElementById("num_pedido").value;
                    if (num_pedido == '') {
                        cp.call('../../ctm/asp/ctm2004b.asp', 'VerificaNR', MontaComboNR, cod_prestador_ts, mes_ano_ref, 'get_ctm_nr_grd');
                    } else {
                        alert("Limpe os dados de Autorização para pesquisar por Contas Médicas.");
                    }
                }
            }

            function AbreLeituraOcr(linha) {
                var pagina = '';
                pagina += '../../ctm/asp/ctm2004c.asp?PT=<%=txt_subtitulo%>';
                if (document.form01.num_pedido.value != '') {
                    pagina += '&num_pedido=' + document.form01.num_pedido.value;
                }
                if (document.form01.cod_ts_conta.value != '') {
                    pagina += '&cod_ts_conta=' + document.form01.cod_ts_conta.value;
                }
                if (document.getElementById('nom_arq_anexo_'+linha).value != '') {
                    pagina += '&nom_arq_anexo=' + document.getElementById('nom_arq_anexo_'+linha).value;
                }
                if (document.getElementById('cod_leitura_doc_'+linha).value != '') {
                    pagina += '&cod_leitura_doc=' + document.getElementById('cod_leitura_doc_'+linha).value;
                }
                if (document.getElementById('p_cod_nr').value != '') {
                    pagina += '&nr_grd=' + document.getElementById('p_cod_nr').value;
                }
                if (document.getElementById('cod_prestador').value != '') {
                    pagina += '&cod_prestador=' + document.getElementById('cod_prestador').value;
                }
                if (document.getElementById('p_mes_ano_ref').value != '') {
                    pagina += '&mes_ano_ref=' + document.getElementById('p_mes_ano_ref').value;
                }
                document.form01.action = pagina;
                document.form01.submit();
            }

            function MontaComboNR(sDescricao) {
                document.getElementById('dv_nr').innerHTML = sDescricao;
                document.getElementById('dv_nr').focus();
                document.getElementById('dv_conta').innerHTML = "<select></select>";

                <%if Request("voltar") = "S" then%>
                    var nr_grd = "<%=Request("nr_grd")%>";
                    var cod_ts_conta = "<%=Request("cod_ts_conta")%>";
                    if (document.getElementById("cod_prestador_ts").value) {
                        if (nr_grd != "") {
                            document.getElementById("p_cod_nr").value = nr_grd;
                            recuperaContas();
                            document.getElementById("cod_ts_conta").value = cod_ts_conta;
                            anexosConta();
                        }
                    }
                <%end if%>
            }

            function recuperaContas() {
                var cod_prestador_ts = document.getElementById("cod_prestador_ts").value;
                var mes_ano_ref = "01/" + document.getElementById("p_mes_ano_ref").value;
                var cod_nr = document.getElementById("p_cod_nr").value;
                var num_pedido = document.getElementById("num_pedido").value;
                if (num_pedido == '') {
                    RecuperaComboConta(cod_prestador_ts, mes_ano_ref, cod_nr)
                } else {
                    alert("Limpe os dados de Autorização para pesquisar por Contas Médicas.");
                }
            }

            function RecuperaComboConta(cod_prestador_ts, mes_ano_ref, cod_nr) {
                var cp = new cpaint();
                cp.set_transfer_mode('get');
                cp.set_response_type('text');
                cp.set_debug(false);
                cp.set_async(false); 
                if (mes_ano_ref != '' && cod_prestador_ts != '' && cod_nr != '') {
                    cp.call('../../ctm/asp/ctm2004b.asp', 'RecuperaComboConta', MontaComboConta, cod_prestador_ts, mes_ano_ref, cod_nr);		 
                }
            }

            function MontaComboConta(sDescricao) {
                document.getElementById('dv_conta').innerHTML = sDescricao;
                document.getElementById('dv_conta').focus();
            }

            function anexosConta() {
                var mes_ano_ref;
                var cod_ts_conta = document.getElementById("cod_ts_conta").value;
                var cod_nr = document.getElementById("p_cod_nr").value;
                var num_pedido = document.getElementById("num_pedido").value;
                mes_ano_ref = "01/" + document.getElementById("p_mes_ano_ref").value;
                if (num_pedido == '') {
                    RecuperaAnexosConta(cod_ts_conta, mes_ano_ref, cod_nr);
                } else {
                    alert("Limpe os dados de Autorização para pesquisar por Contas Médicas.");
                }
            }

            function RecuperaAnexosConta(cod_ts_conta, mes_ano_ref, cod_nr) {
                var cp = new cpaint();
                cp.set_transfer_mode('get');
                cp.set_response_type('text');
                cp.set_debug(false);
                cp.set_async(false); 
                if (mes_ano_ref != '' && cod_ts_conta != '' && cod_nr != '') {
                    cp.call('../../ctm/asp/ctm2004b.asp', 'RecuperaAnexosConta', MontaAnexosConta, cod_ts_conta, mes_ano_ref, cod_nr);		 
                }
            }

            function MontaAnexosConta(sDescricao) {
                document.getElementById('dv_anexos').innerHTML = sDescricao;
                document.getElementById('dv_anexos').focus();
            }

        </script>
    </html>
</form>

<%
if Request("voltar") = "S" then
    call montaDadosRetorno()
end if

sub montaDadosRetorno() 
    %>
    <script>
        var num_pedido = "<%=Request("num_pedido")%>";
        var mes_ano_ref = "<%=Request("mes_ano_ref")%>";
        var cod_prestador = "<%=Request("cod_prestador")%>";

        if (num_pedido == "" && cod_prestador != "" && mes_ano_ref != "") {
            document.getElementById("cod_prestador").value = cod_prestador;
            document.getElementById("p_mes_ano_ref").value = mes_ano_ref;
            if (document.getElementById("cod_prestador").value) {
                CarregaPrestador();
            }
        }
    </script>
    <%
end sub

sub exibeGrid()
	if trim(num_pedido) <> "" then

        Dim vet_PL(7,4)

        vet_PL(1, 1) = "IN"
        vet_PL(1, 2) = "adVarChar"
        vet_PL(1, 3) = "p_num_pedido"
        vet_PL(1, 4) = num_pedido

        vet_PL(2, 1) = "IN"
        vet_PL(2, 2) = "adVarChar"
        vet_PL(2, 3) = "p_cod_tipo_usuario"
        vet_PL(2, 4) = session("ace_tipo_usuario")

        vet_PL(3, 1) = "IN"
        vet_PL(3, 2) = "adVarChar"
        vet_PL(3, 3) = "p_cod_usuario"
        vet_PL(3, 4) = txt_usuario

        vet_PL(4, 1) = "IN"
        vet_PL(4, 2) = "adVarChar"
        vet_PL(4, 3) = "p_cod_identificacao_ts"
        vet_PL(4, 4) = session("ace_identificacao_ts")

        vet_PL(5, 1) = "OUT"
        vet_PL(5, 2) = "adLongVarChar"
        vet_PL(5, 3) = "p_xml_autorizacao"

        vet_PL(6, 1) = "OUT"
        vet_PL(6, 2) = "adDouble"
        vet_PL(6, 3) = "p_cod_retorno"

        vet_PL(7, 1) = "OUT"
        vet_PL(7, 2) = "adVarChar"
        vet_PL(7, 3) = "p_msg_retorno"

        Call ExecutaPLOracle(CStr(txt_usuario),_
                             CStr(txt_senha),_
                             CStr(txt_ip),_
                             CStr(txt_sistema),_
                             CStr(txt_modulo),_
                             "AUT_RCS_PEDIDO_AUTORIZACAO.get_xml_pedido_com_anexo", _
                             vet_PL, _
                             false )

        if vet_PL(6, 4) <> "0" then
            txt_msg = vet_PL(7, 4)
            Session("txt_msg") = txt_msg
            num_pedido  = ""
            bErroAoCarregar = true
        else
            xml_autorizacao = vet_PL(5, 4)   
		    call MontaDadosAnexo()  
        end if  
    end if
end sub

sub MontaDadosAnexo()
    Dim sCaminhoArquivo, cor, qtd_anexos, msg, oXML, oAnexoXML, x
    
    AbreTable()
    %>
    <table width="100%" align="center">
        <tr bgcolor="#e2eFe5">
			<td width="10%" class="label_left">Pedido&nbsp;</td>
			<td width="5%" class="label_left">Sequência&nbsp;</td>
            <td width="15%" class="label_left">Data&nbsp;</td>
            <td width="20%" class="label_left">Tipo de documento&nbsp;</td>  
			<td width="40%" class="label_left">Nome do arquivo&nbsp;</td>
            <td width="5%" class="label_left">Anexo&nbsp;</td>  
            <td width="5%" class="label_left">OCR&nbsp;</td>
        </tr>
        <%
        cor = true
        qtd_anexos = 0
        
        Set oXML = CreateObject("Microsoft.XMLDOM") 
        oXML.async = False 
        oXML.loadXML(xml_autorizacao)

        Set oAnexoXML = oXML.getElementsByTagName("AUTORIZACAO_ANEXO/DADOS")	
        
        For x = 0 To oAnexoXML.Length - 1
            if ind_acesso_cam <> "S" or (ind_acesso_cam = "S" and LerXML(x, "IND_VISUALIZA_INPART", oAnexoXML) = "S") then
                cor  = not cor
                qtd_anexos = cint(qtd_anexos) + 1

				sCaminhoArquivo = LerXML(x, "NOM_ARQ_ANEXO", oAnexoXML)
				
                if not arquivoExiste(sCaminhoArquivo) then
                	if GetFilename(sCaminhoArquivo) = "" then
                    	sCaminhoArquivo = GetDiretorioArquivo ( LerXMLLoop(x, "NOM_ARQ_ANEXO", oAnexoXML) )
                    	sCaminhoArquivo = sCaminhoArquivo & "/" & CStr(LerXMLLoop(x, "NOM_ARQ_ANEXO", oAnexoXML))
                	end if
                end if
					
                if not arquivoExiste(sCaminhoArquivo) then
                    sCaminhoArquivo = GetDiretorioArquivo ( LerXMLLoop(x, "NOM_ARQ_ANEXO", oAnexoXML) )
                    sCaminhoArquivo = sCaminhoArquivo & "/" & num_pedido & "_" & CStr(LerXMLLoop(x, "NOM_ARQ_ANEXO", oAnexoXML))
        
                    if not arquivoExiste(sCaminhoArquivo) then
                        sCaminhoArquivo = ""
                        sCaminhoArquivo = GetDiretorioArquivo ( LerXMLLoop(x, "NOM_ARQ_ANEXO", oAnexoXML) )
                        sCaminhoArquivo = sCaminhoArquivo & "/" & CStr(LerXMLLoop(x, "NOM_ARQ_ANEXO", oAnexoXML))

                        if not arquivoExiste(sCaminhoArquivo) then
                            sCaminhoArquivo = ""
                            sCaminhoArquivo = GetDiretorioArquivo ( LerXMLLoop(x, "NOM_ARQ_ANEXO", oAnexoXML) )
                            sCaminhoArquivo = sCaminhoArquivo & "/Prorrog_" & num_pedido & "_" & CStr(LerXMLLoop(x, "NOM_ARQ_ANEXO", oAnexoXML))

                            if not arquivoExiste(sCaminhoArquivo) then
                                sCaminhoArquivo = ""
                                sCaminhoArquivo = GetDiretorioArquivo ( LerXMLLoop(x, "NOM_ARQ_ANEXO", oAnexoXML) )
                                sCaminhoArquivo = sCaminhoArquivo & "/Prorrog_" & CStr(LerXMLLoop(x, "NOM_ARQ_ANEXO", oAnexoXML))

                                if not arquivoExiste(sCaminhoArquivo) then
                                    sNome              = CStr( LerXMLLoop(x, "NOM_ARQ_ANEXO", oAnexoXML) )
                                    ExtraiNomeCompleto = mid(sNome, InstrRev(sNome,"\",-1)+1, len(sNome) )
                                    ExtraiNomeOk       = mid(ExtraiNomeCompleto, instr(ExtraiNomeCompleto,"_")+1, len(ExtraiNomeCompleto))
                                    sCaminhoArquivo    = GetDiretorioArquivo (ExtraiNomeOk)
                                    sCaminhoArquivo    = sCaminhoArquivo & "/" & ExtraiNomeOk
                                end if
                            end if
                        end if
                    end if
                end if 
            %>
                <input type="hidden" name="txt_caminho_arquivo_<%=x%>" id="txt_caminho_arquivo_<%=x%>" value="<%=sCaminhoArquivo%>" />
                <div id="txt_msg" class="msg" align="center"><%=txt_msg%></div>
                <tr <%if cor then Response.Write "bgcolor=#E2EFE5"%>>
                    <td class="label_left"><%=num_pedido%></td>
                    <td class="label_left"><%=LerXML(x, "NUM_SEQ_PEDIDO", oAnexoXML)%></td>
                    <td class="label_left"><%=LerXML(x, "DT_ANEXADO", oAnexoXML)%>&nbsp;</td>      
                    <td class="label_left" ><%=left(LerXML(x, "NOME_DESC_ANEXO", oAnexoXML), 20)%>
                        <%
                        msg = LerXML(x, "NOME_DESC_ANEXO", oAnexoXML)
                        if len(msg) > 20 then
                            msg = replace(msg, "'", "\'")
                            msg = replace(msg, chr(13), "")
                            msg = replace(msg, chr(10), "<br>")
                            %>
                            ... <img alt="Clique para ver o texto completo." SRC="/gen/img/folha_1.gif" onclick="mostra_detalhe('<%=msg%>')" style="cursor:'hand'">&nbsp;
                            <%
                        end if
                        %>
                    </td>
                    <td width="40%" class="label_left"><%=LerXML(x, "NOM_ARQ_ANEXO", oAnexoXML)%></td>
                    <input type="hidden" name="nom_arq_anexo_<%=qtd_anexos%>" id="nom_arq_anexo_<%=qtd_anexos%>" value="<%=LerXML(x, "NOM_ARQ_ANEXO", oAnexoXML)%>">
                    <td class="label_center" align=center valign=middle>
                        <%if LerXMLLoop(x, "GUID_DOC_NUVEM", oAnexoXML) <> "" then %>
                            <a target=blank  onclick="downloadFile('<%=LerXMLLoop(x, "GUID_DOC_NUVEM", oAnexoXML)%>')" title="<%=LerXMLLoop(x, "NOM_ARQ_ANEXO", oAnexoXML)%>" style="cursor: pointer;">
                                <img border=0 src="/gen/img/clips_1.gif" />
                            </a>
                        <%elseif LerXML(x, "NOM_ARQ_ANEXO", oAnexoXML) <> "" then%>
                            <a target=blank href="<%=sCaminhoArquivo%>" title="<%=LerXML(x, "NOM_ARQ_ANEXO", oAnexoXML)%>"><img border=0 src="/gen/img/clips_1.gif"></a>
                        <%else%>
                            &nbsp;
                        <%end if%>
                    </td>
                    <td width="5%" class="label_center"><%
                        cod_leitura_doc = LerXMLLoop(x, "COD_LEITURA_DOC", oAnexoXML)
                        if cod_leitura_doc <> "" then
                        %>
                            <img id='leitura_ocr' style='cursor:pointer;cursor:hand' name='leitura_ocr' id='Pesquisa_Pedido' width='16' height='16' src='/gen/img/conf_exec_.png' border='0' title='Leitura OCR' onClick='AbreLeituraOcr(<%=qtd_anexos%>);' >
                        <% end if%>
                        <input type="hidden" name="nom_arq_anexo_<%=qtd_anexos%>" id="nom_arq_anexo_<%=qtd_anexos%>" value="<%=LerXML(x, "NOM_ARQ_ANEXO", oAnexoXML)%>">
                        <input type="hidden" name="cod_leitura_doc_<%=qtd_anexos%>" id="cod_leitura_doc_<%=qtd_anexos%>" value="<%=cod_leitura_doc%>">
                    </td>
                </tr>
            <%
            end if
        next
        Set oAnexoXML = Nothing
        %>
        
        <input type="hidden" name="qtd_anexos" id="qtd_anexos" value="<%=qtd_anexos%>"/>
    </table>

    <%FechaTable()

end sub

sub MontaDadosAnexoContas()	
    %>
    <div id="dv_anexos" name="dv_anexos"></div>
    <%
end sub

function LerXML(pIndice, pNomeNo, pObjeto)
    on error resume next
    LerXML = pObjeto.Item(pIndice).selectSingleNode("./" & pNomeNo).Text
    if err.number <> 0 then
        LerXML = ""
    end if
    on error goto 0
end function

function GetDiretorioArquivo(pNomeArquivo)
    Dim sDir

    sDir = RetornaParametro("AT_CAMINHO_ANEXO_LER_FISICO", "")

    'Verificar se o arquivo existe na pasta indicada
    if sDir = "" or ExisteArquivoDiretorio(pNomeArquivo, sDir) = false then
        sDir = RetornaParametro("AT_CAMINHO_ANEXO", "")
    else
        sDir = RetornaParametro("AT_CAMINHO_ANEXO_LER", "")
    end if

    GetDiretorioArquivo = sDir
	GetDiretorioArquivo = replace(GetDiretorioArquivo,"\","/") 'Preciso mudar para o MultiBrowser
end function

function RetornaParametro(pCodParametro, pValDefault)
	Dim vetParam(3, 4)

	vetParam(1, 1) = "OUT"
	vetParam(1, 2) = "adVarChar"
	vetParam(1, 3) = "p_val_parametro"

	vetParam(2, 1) = "IN"
	vetParam(2, 2) = "adVarChar"
	vetParam(2, 3) = "p_cod_parametro"
	vetParam(2, 4) = pCodParametro

	vetParam(3, 1) = "IN"
	vetParam(3, 2) = "adVarChar"
	vetParam(3, 3) = "p_val_default"
	vetParam(3, 4) = pValDefault

	Call ExecutaPLOracle (	CStr(txt_usuario),_
	  						CStr(txt_senha),_
							CStr(txt_ip),_
							CStr(txt_sistema),_
							CStr(txt_modulo),_
							"AUT_RCS_CONSULTA_PEDIDO.get_controle_sistema", _
							vetParam, _
							false )

	FechaConexao()

	RetornaParametro = vetParam(1, 4)
end function

function ExisteArquivoDiretorio(pNomeArquivo, pDiretorio)
    Dim oFSO, sArquivo, bRetorno, posicao

    if right(pDiretorio,1) <> "/" and right(pDiretorio,1) <> "\" then
        sArquivo = pDiretorio & "/" & pNomeArquivo
    else
        sArquivo = pDiretorio & pNomeArquivo
    end if
    
    set oFSO = Server.CreateObject("Scripting.FileSystemObject")
    bRetorno = oFSO.FileExists ( sArquivo )
	set oFSO = nothing

    ExisteArquivoDiretorio = bRetorno
end function

'VOLTAR/CONTINUAR/LIMPAR/INCLUIR/ALTERAR/EXCLUIR/EXECUTAR
if ind_leitura = "S" then
    call MontaToolbar("S","N","S","N","N","N","N","N")
else
    call MontaToolbar("N","S","S","N","N","N","N","N")
end if

%>
