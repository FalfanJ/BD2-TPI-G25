<%@ Page Title="Ver Artículo" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="VerArticulo.aspx.cs" Inherits="Presentacion.VerArticulo" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row">
        <div class="col-md-10 offset-md-1">
            
            <h2 class="mt-4"><asp:Literal ID="litTitulo" runat="server"></asp:Literal></h2>
            <p class="text-muted">
                Escrito por: <asp:Literal ID="litAutor" runat="server"></asp:Literal>
            </p>
            <hr />

            <div class="bg-light p-4 rounded">
                <p>
                    <asp:Literal ID="litSolucion" runat="server"></asp:Literal>
                </p>
            </div>

            <a href="Home.aspx" class="btn btn-primary mt-3">Volver</a>
        </div>
    </div>
</asp:Content>