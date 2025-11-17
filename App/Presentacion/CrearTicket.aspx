<%@ Page Title="Crear Ticket" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CrearTicket.aspx.cs" Inherits="Presentacion.CrearTicket" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="row">
        <div class="col-md-8 offset-md-2">
            <h2 class="mt-4">Crear Nuevo Ticket</h2>
            <hr />

            <div class="mb-3">
                <label class="form-label">Título del Ticket</label>
                <asp:TextBox ID="txtTitulo" runat="server" CssClass="form-control" />
            </div>

            <div class="mb-3">
                <label class="form-label">Mis Equipos</label>
                <asp:DropDownList ID="ddlEquipos" runat="server" CssClass="form-select" />
            </div>

            <div class="mb-3">
                <label class="form-label">Tipo de Ticket</label>
                <asp:DropDownList ID="ddlTiposTicket" runat="server" CssClass="form-select" />
            </div>

            <div class="mb-3">
                <label class="form-label">Descripción del Problema</label>
                <asp:TextBox ID="txtDescripcion" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="5" />
            </div>
            
            <div class="mb-3">
                <asp:Button ID="btnGuardar" runat="server" Text="Enviar Ticket" CssClass="btn btn-primary" OnClick="btnGuardar_Click" />
                <a href="Home.aspx" class="btn btn-secondary">Cancelar</a>
            </div>

            <asp:Label ID="lblMensaje" runat="server" CssClass="text-success" Visible="false" />

        </div>
    </div>

</asp:Content>
