<%@ Page Title="Crear Artículo" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CrearArticulo.aspx.cs" Inherits="Presentacion.CrearArticulo" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row">
        <div class="col-md-8 offset-md-2">
            <h2 class="mt-4">Crear Nuevo Artículo de Conocimiento</h2>
            <hr />

            <div class="mb-3">
                <label class="form-label">Título</label>
                <asp:TextBox ID="txtTitulo" runat="server" CssClass="form-control" />
                <asp:RequiredFieldValidator ErrorMessage="Se requiere un título." ControlToValidate="txtTitulo" 
                    CssClass="text-danger" Display="Dynamic" runat="server" />
            </div>

            <div class="mb-3">
                <label class="form-label">Solución (Detallada)</label>
                <asp:TextBox ID="txtSolucion" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="10" />
                <asp:RequiredFieldValidator ErrorMessage="Se requiere una solución." ControlToValidate="txtSolucion"
                    CssClass="text-danger" Display="Dynamic" runat="server" />
            </div>
            
            <div class="mb-3">
                <asp:Button ID="btnGuardar" runat="server" Text="Guardar Artículo" CssClass="btn btn-success" OnClick="btnGuardar_Click" />
                <a href="Home.aspx" class="btn btn-secondary">Cancelar</a>
            </div>

            <asp:Label ID="lblError" runat="server" CssClass="text-danger" Visible="false" />
        </div>
    </div>
</asp:Content>