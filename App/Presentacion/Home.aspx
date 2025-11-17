<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="Presentacion.Home" %>

<!DOCTYPE html>
<html lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <title>Página Principal - Mesa de Ayuda</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body class="bg-light">
    <form id="form1" runat="server">
        
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
            <div class="container">
                <a class="navbar-brand" href="#">Mesa de Ayuda</a>
                <div class="collapse navbar-collapse">
                    <ul class="navbar-nav ms-auto">
                        <li class="nav-item">
                            <span class="navbar-text">
                                Hola, <asp:Label ID="lblNombreUsuario" runat="server"></asp:Label>
                            </span>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <div class="container mt-4">

            <asp:Panel ID="pnlCliente" runat="server" Visible="false">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h2>Mis Tickets</h2>
                    <asp:Button ID="btnIrACrearTicketCliente" runat="server" Text="Crear Nuevo Ticket" CssClass="btn btn-primary" OnClick="btnIrACrearTicket_Click" />
                </div>

                <asp:GridView ID="gvMisTickets" runat="server" CssClass="table table-hover table-striped" AutoGenerateColumns="false" GridLines="None">
                    <Columns>
                        <asp:HyperLinkField 
            DataNavigateUrlFields="Id_Ticket" 
            DataNavigateUrlFormatString="VerTicket.aspx?id={0}"
            DataTextField="Id_Ticket" 
            HeaderText="ID" />
                        <asp:BoundField DataField="Titulos" HeaderText="Título" />
                        <asp:BoundField DataField="Fecha" HeaderText="Fecha" DataFormatString="{0:d}" />
                        <asp:BoundField DataField="EstadoTicket.NombreEstado" HeaderText="Estado" />
                        <asp:BoundField DataField="Tecnico.Nombre" HeaderText="Asignado a" NullDisplayText="Sin Asignar" />
                    </Columns>
                    <EmptyDataTemplate>
                        <div class="alert alert-info">No tenés tickets reportados.</div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </asp:Panel>

            <asp:Panel ID="pnlTecnico" runat="server" Visible="false">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h2>Panel de Técnico</h2>
                    <asp:Button ID="btnIrACrearTicketTecnico" runat="server" Text="Crear Nuevo Ticket" CssClass="btn btn-primary" OnClick="btnIrACrearTicket_Click" />
                </div>

                <ul class="nav nav-tabs" id="tecnicoTabs" role="tablist">
                    <li class="nav-item" role="presentation"><button class="nav-link active" id="asignados-tab" data-bs-toggle="tab" data-bs-target="#asignados" type="button" role="tab">Mis Tickets</button></li>
                    <li class="nav-item" role="presentation"><button class="nav-link" id="sinasignar-tab" data-bs-toggle="tab" data-bs-target="#sinasignar" type="button" role="tab">Sin Asignar</button></li>
                    <li class="nav-item" role="presentation"><button class="nav-link" id="conocimiento-tab" data-bs-toggle="tab" data-bs-target="#conocimiento" type="button" role="tab">Conocimiento</button></li>
                    <li class="nav-item" role="presentation"><button class="nav-link" id="inventario-tab" data-bs-toggle="tab" data-bs-target="#inventario" type="button" role="tab">Inventario</button></li>
                </ul>

                <div class="tab-content" id="tecnicoTabsContent">
                    
                    <div class="tab-pane fade show active p-3 border-start border-end border-bottom" id="asignados" role="tabpanel">
                        <asp:GridView ID="gvTicketsAsignados" runat="server" CssClass="table table-hover table-striped" AutoGenerateColumns="false" GridLines="None">
                            <Columns>
                                <asp:HyperLinkField 
            DataNavigateUrlFields="Id_Ticket" 
            DataNavigateUrlFormatString="DetalleTicket.aspx?id={0}"
            DataTextField="Id_Ticket" 
            HeaderText="ID" />
                                <asp:BoundField DataField="Titulos" HeaderText="Título" />
                                <asp:BoundField DataField="Cliente.Nombre" HeaderText="Cliente" />
                                <asp:BoundField DataField="EstadoTicket.NombreEstado" HeaderText="Estado" />
                                <asp:BoundField DataField="SLA.Nivel" HeaderText="SLA" NullDisplayText="N/A" />
                            </Columns>
                            <EmptyDataTemplate><div class="alert alert-info">No tenés tickets asignados.</div></EmptyDataTemplate>
                        </asp:GridView>
                    </div>

                    <div class="tab-pane fade p-3 border-start border-end border-bottom" id="sinasignar" role="tabpanel">
                        <asp:GridView ID="gvTicketsSinAsignar" runat="server" CssClass="table table-hover table-striped" AutoGenerateColumns="false" GridLines="None">
                            <Columns>
                                <asp:HyperLinkField 
    DataNavigateUrlFields="Id_Ticket" 
    DataNavigateUrlFormatString="DetalleTicket.aspx?id={0}"
    DataTextField="Id_Ticket" 
    HeaderText="ID" />
                                <asp:BoundField DataField="Titulos" HeaderText="Título" />
                                <asp:BoundField DataField="Cliente.Nombre" HeaderText="Cliente" />
                                <asp:BoundField DataField="Fecha" HeaderText="Fecha" DataFormatString="{0:g}" />
                            </Columns>
                            <EmptyDataTemplate><div class="alert alert-success">¡No hay tickets en la cola!</div></EmptyDataTemplate>
                        </asp:GridView>
                    </div>
                    
                    <div class="tab-pane fade p-3 border-start border-end border-bottom" id="conocimiento" role="tabpanel">
                        <div class="d-flex justify-content-end mb-3">
        <asp:HyperLink NavigateUrl="AgregarArticulo.aspx" Text="Crear Nuevo Artículo" 
            CssClass="btn btn-success" runat="server" />
    </div>
                        <asp:GridView ID="gvBaseConocimiento" runat="server" CssClass="table table-hover table-striped" AutoGenerateColumns="false" GridLines="None">
                            <Columns>
                                <asp:HyperLinkField 
                DataNavigateUrlFields="Id_Articulo" 
                DataNavigateUrlFormatString="VerArticulo.aspx?id={0}"
                DataTextField="Titulo" 
                HeaderText="Título" />
                                <asp:BoundField DataField="Titulo" HeaderText="Título" />
                                <asp:BoundField DataField="Autor.Nombre" HeaderText="Autor" />
                            </Columns>
                            <EmptyDataTemplate><div class="alert alert-info">No hay artículos.</div></EmptyDataTemplate>
                        </asp:GridView>
                    </div>
                    
                    <div class="tab-pane fade p-3 border-start border-end border-bottom" id="inventario" role="tabpanel">
                        <asp:GridView ID="gvInventario" runat="server" CssClass="table table-hover table-striped" AutoGenerateColumns="false" GridLines="None">
                            <Columns>
                                <asp:BoundField DataField="Id_Equipo" HeaderText="ID" />
                                <asp:BoundField DataField="Nombre" HeaderText="Equipo" />
                                <asp:BoundField DataField="Marca.Nombre" HeaderText="Marca" />
                                <asp:BoundField DataField="Modelo" HeaderText="Modelo" NullDisplayText="-" />
                                <asp:BoundField DataField="NumeroSerie" HeaderText="N° Serie" NullDisplayText="-" />
                                <asp:BoundField DataField="Estado" HeaderText="Estado" />
                            </Columns>
                            <EmptyDataTemplate><div class="alert alert-info">No hay equipos cargados.</div></EmptyDataTemplate>
                        </asp:GridView>
                    </div>
                </div>
            </asp:Panel>
        </div>
    </form>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>