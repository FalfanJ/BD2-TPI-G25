<%@ Page Title="Detalle de Ticket" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="DetalleTicket.aspx.cs" Inherits="Presentacion.DetalleTicket" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
    <%-- Label para guardar el ID del ticket --%>
    <asp:Label ID="lblTicketID" runat="server" Visible="false"></asp:Label>

    <div class="row">
        <div class="col-md-8">
            <h2 class="mt-4">
                <asp:Literal ID="litTitulo" runat="server"></asp:Literal>
            </h2>
            <hr />

            <div class="card mb-3">
                <div class="card-body">
                    <h5 class="card-title">Detalles del Reporte</h5>
                    <p>
                        <strong>Cliente:</strong> <asp:Literal ID="litCliente" runat="server"></asp:Literal><br />
                        <strong>Equipo:</strong> <asp:Literal ID="litEquipo" runat="server"></asp:Literal><br />
                        <strong>Fecha Reporte:</strong> <asp:Literal ID="litFecha" runat="server" ></asp:Literal><br />
                    </p>
                    <strong>Descripción Original:</strong>
                    <p class="card-text bg-light p-2 rounded">
                        <asp:Literal ID="litDescripcion" runat="server"></asp:Literal>
                    </p>
                </div>
            </div>

            <h4 class="mt-4">Historial y Comentarios</h4>
         <h4 class="mt-4">Historial y Comentarios</h4>
<asp:Repeater ID="rptHistorial" runat="server">
    <ItemTemplate>
        <div class="card mb-2">
            <div class="card-body p-3">
                <p class="card-text"><%# Eval("Descripcion") %></p>
                <small class="text-muted">
                    <strong><%# Eval("Modificado_Por.Nombre") %></strong> 
                    - <%# Eval("FechaModificacion", "{0:g}") %> 
                    (Estado: <%# Eval("EstadoTicket.NombreEstado") %>)
                </small>
            </div>
        </div>
    </ItemTemplate>
</asp:Repeater>

        </div>
        <div class="col-md-4">
            <h4 class="mt-4">Acciones de Técnico</h4>

            <div class="card mb-3">
                <div class="card-body">
                    <h5 class="card-title">Prioridad (SLA)</h5>
                    <asp:DropDownList ID="ddlSLA" runat="server" CssClass="form-select mb-2"></asp:DropDownList>
                    <asp:Button ID="btnActualizarSLA" runat="server" Text="Actualizar SLA" CssClass="btn btn-sm btn-outline-secondary" OnClick="btnActualizarSLA_Click" />
                </div>
            </div>

            <div class="card mb-3">
                <div class="card-body">
                    <h5 class="card-title">Actualizar Ticket</h5>
                    
                    <div class="mb-3">
                        <label class="form-label">Nuevo Comentario:</label>
                        <asp:TextBox ID="txtNuevoComentario" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4"></asp:TextBox>
                        <asp:RequiredFieldValidator ErrorMessage="Se requiere un comentario." ControlToValidate="txtNuevoComentario" CssClass="text-danger" Display="Dynamic" runat="server" />
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Cambiar Estado a:</label>
                        <asp:DropDownList ID="ddlNuevoEstado" runat="server" CssClass="form-select"></asp:DropDownList>
                    </div>

                    <asp:Button ID="btnActualizarTicket" runat="server" Text="Enviar Actualización" CssClass="btn btn-primary w-100" OnClick="btnActualizarTicket_Click" />
                    <asp:Label ID="lblError" runat="server" CssClass="text-danger" Visible="false"></asp:Label>
                </div>
            </div>

        </div>
    </div>
</asp:Content>
