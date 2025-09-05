<%@ LANGUAGE="VBSCRIPT" %>
<%

    dim txt_usuario, txt_senha, txt_ip, txt_modulo, txt_sistema
    dim txt_subtitulo, txt_msg, cod_leitura_doc, vet_PL(1, 4), classe
    dim ind, ind_campo_valido, nom_tipo_doc_campo, val_doc_campo, val_conf_campo

    txt_usuario     = Session("ace_usuario")
    txt_senha       = Session("ace_senha")
    txt_ip          = Session("ace_ip")
    txt_modulo      = Session("ace_modulo")
    txt_sistema     = Session("ace_sistema")
    txt_msg         = Session("txt_msg")
    txt_subtitulo   = Request.QueryString("PT")
    num_reembolso    = Request("num_reembolso")
    cod_ts_conta    = Request.QueryString("cod_ts_conta") 
    nom_arq_anexo   = Request("nom_arq_anexo")
    cod_leitura_doc = Request("cod_leitura_doc")
    nr_grd          = Request("nr_grd")
    cod_prestador   = Request("cod_prestador")
    mes_ano_ref     = Request("mes_ano_ref")

    ind = 0
%>

<!--#include file=..\..\gen\inc\inc0000.asp-->
<!--#include file=..\..\gen\inc\inc0001.asp-->
<!--#include file=..\..\gen\inc\inc0002.asp-->
<!--#include file=../../gen/asp/gen0146a.asp-->
<!--#include file=../../gen/asp/gen0146b.asp-->

<html>
    <head>
        <link href="/gen/css/css002.css?contexto=<%=session("contexto")%>" rel="stylesheet" type="text/css">
		<script type="text/javascript" src="/gen/js/waitbar.js"></script>
        <style>
            .subtitulo{
                color:darkblue;
            }
            .label_t{
                color:#000080;
                font-family:Verdana;
                text-align:left;
                font-size:8pt;
                font-weight:bold;
            }
        </style>
    </head>
    <%AbreTable()%>
		<font class="subtitulos"><%=txt_subtitulo%></font>
	<%FechaTable()%>
    <body>
	
        <fieldset class="label_left">
            <table id="busca_">
                <tr>                 
                        <td><span class='subtitulo' style="margin-left:37px" size="25">Nº Pedido:</span>&nbsp;</td>
                        <td>
                            <input type='text' Readonly class="camposblocks" value='<%=num_reembolso%>' size="23">&nbsp;
                        </td>                  
                </tr>
                <tr>
                    <td><span class='subtitulo' style="margin-left:37px">Arquivo:</span>&nbsp;</td>
                    <td>
					
                        <input type='text' name='nom_arq_anexo' Readonly class="camposblocks" id='nom_arq_anexo' value='\integracao_utldir\pagamento\2025\09\02\09\5364807316_296dbedb978c4ab0849708a66da723db.png' size='100'  tabindex='1' onKeyPress='javascript:MascInt()' OnKeyDown='TeclaEnter();' onChange='javascript:this.value=Trim(this.value);ValidaInt(event);reexecute();'>&nbsp;
                    </td>
                </tr>
            </table>
        </fieldset>
		
        <td width='15%' class='label_right'>&nbsp;</td>
        <fieldset class="label_left">
            <legend class="label_t">Parâmetros</legend>
            <tr><td>&nbsp;</td></tr>
			
            <table id="busca_">
                <tr>               
                    <td><span class='subtitulo' style="margin-left:37px">Tipo de Documento:</span>&nbsp;</td>
                    <td>
                        <input type='text' name='nom_tipo_documento' id='nom_tipo_documento' value='Orçamento' size='50'  tabindex='1' Readonly class="camposblocks" onKeyPress='javascript:MascInt()' OnKeyDown='TeclaEnter();' onChange='javascript:this.value=Trim(this.value);ValidaInt(event);reexecute();'>&nbsp;
                    </td>
                </tr>
            </table>
        </fieldset>
        <td width='15%' class='label_right'>&nbsp;</td>
        <fieldset class="label_left">
            <legend class="label_t">Dados Estruturados</legend>
            <tr><td>&nbsp;</td></tr>
            <table id="busca_">
                <tr>
                    <td><span class='subtitulo' style="margin-left:37px">Percentual de Validação:</span>&nbsp;</td>
                    <td>
                        <input type='text' name='val_conficaca_doc' id='' value='99'size='15' maxlength='25' Readonly class="camposblocks" tabindex='1' onKeyPress='javascript:MascInt()' OnKeyDown='TeclaEnter();' onChange='javascript:this.value=Trim(this.value);ValidaInt(event);reexecute();'>&nbsp;
                    </td>
                </tr>     
                <tr><td>&nbsp;</td></tr>
            </table>
            <table width='100%' id='tbl_leitura_ocr' align='center'>
                <tr>
                    <td width='30%' bgcolor="#e2eFe5" class='label_center'>Campos&nbsp;</td>
                    <td width='50%' bgcolor="#e2eFe5" class='label_center'>Leitura OCR&nbsp;</td>
                    <td width='15%' bgcolor="#e2eFe5" class='label_center'>Taxa de Confiança&nbsp;</td>
                    <td width='5%' class='label_center'></td>
                </tr>
               

                    <tr class="<%=classe%>" >              
                        <td>
                            <span><%=nom_tipo_doc_campo%> Teste</span>		
                        </td> 
                        <td>
                            <span><%=val_doc_campo%>Teste</span>		
                        </td> 
                        <td>
                            <span><%=val_conf_campo%>99</span>
                        </td>
                        <td style="background-color: transparent;">
                            <%if ind_campo_valido = "N" then%>
                                &nbsp;&nbsp;<img align='middle' style='cursor:hand' width='20' height='20' src='/gen/img/aviso_vermelho.gif'  border='0' title='Divergências encontradas'>
                            <%end if%>	
                        </td>
    
            </table>
        </fieldset>
    </body>
    <script>
        function acao_voltar() {
            var pagina = '';
            pagina += '../../ctm/asp/rbm1123a.asp?PT=<%=num_reembolso%>&voltar=S';
            <% if num_reembolso <> "" then %>
                pagina += '&num_reembolso=' + <%=num_reembolso%>;
            <% end if %>
            
            window.location = pagina;
        }
    </script>
    <%
    'VOLTAR/CONTINUAR/LIMPAR/INCLUIR/ALTERAR/EXCLUIR/EXECUTAR
    call MontaToolbar("S","N","N","N","N","N","N","N")
    %>
</html>