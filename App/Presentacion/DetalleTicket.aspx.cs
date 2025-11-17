using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Dominio;
using Negocio;

namespace Presentacion
{
    public partial class DetalleTicket : System.Web.UI.Page
    {
        private Empleado tecnicoLogueado;

        protected void Page_Load(object sender, EventArgs e)
        {
            // 1. Validar que sea un Técnico
            if (Session["usuario"] == null)
            {
                Response.Redirect("Login.aspx", false);
                return;
            }

            tecnicoLogueado = (Empleado)Session["usuario"];
            if (tecnicoLogueado.Rol.NombreRol != "Tecnico" && tecnicoLogueado.Rol.NombreRol != "Administrador")
            {
                Response.Redirect("Home.aspx", false); // No es técnico, fuera
                return;
            }

            if (Request.QueryString["id"] == null)
            {
                Response.Redirect("Home.aspx", false); // No hay ID, fuera
                return;
            }

            lblTicketID.Text = Request.QueryString["id"];

            if (!IsPostBack)
            {
                CargarDatosDelTicket();
                CargarDropDownLists();
                CargarHistorial();
            }
        }

        private void CargarDatosDelTicket()
        {
            // Necesitarás un TicketsNegocio.ObtenerPorId(int id)
            TicketsNegocio negocio = new TicketsNegocio();
            Tickets ticket = negocio.ObtenerPorId(int.Parse(lblTicketID.Text));

            if (ticket == null)
            {
                Response.Redirect("Home.aspx", false); // Ticket no existe
                return;
            }

            // --- ESTA ES LA LÓGICA DE "AGARRAR" ---
            // Si el ticket no tiene técnico, se lo asignamos al logueado
            if (ticket.Tecnico == null || ticket.Tecnico.Id_Empleado == 0)
            {
                negocio.AgarrarTicket(ticket.Id_Ticket, tecnicoLogueado.Id_Empleado);
                // Volvemos a cargar el ticket para tener los datos actualizados
                ticket = negocio.ObtenerPorId(ticket.Id_Ticket);
            }

            // Cargar datos en la UI
            litTitulo.Text = $"Ticket #{ticket.Id_Ticket}: {ticket.Titulos}";
            litCliente.Text = ticket.Cliente.Nombre + " " + ticket.Cliente.Apellido;
            litEquipo.Text = ticket.Equipo.Nombre;
            litFecha.Text = ticket.Fecha.ToString("g");
            litDescripcion.Text = ticket.Descripcion;
        }

        private void CargarDropDownLists()
        {
            // Cargar SLAs
            SLANegocio slaNegocio = new SLANegocio();
            ddlSLA.DataSource = slaNegocio.Listar();
            ddlSLA.DataValueField = "Id_SLA";
            ddlSLA.DataTextField = "Nivel";
            ddlSLA.DataBind();

            // Cargar Estados
            EstadosTicketNegocio estadoNegocio = new EstadosTicketNegocio();
            ddlNuevoEstado.DataSource = estadoNegocio.Listar(); // Necesitarás esta clase de negocio
            ddlNuevoEstado.DataValueField = "Id_EstadoTicket";
            ddlNuevoEstado.DataTextField = "NombreEstado";
            ddlNuevoEstado.DataBind();

            // Seleccionar los valores actuales del ticket
            TicketsNegocio tktNegocio = new TicketsNegocio();
            Tickets ticket = tktNegocio.ObtenerPorId(int.Parse(lblTicketID.Text));

            if (ticket.SLA != null)
                ddlSLA.SelectedValue = ticket.SLA.Id_SLA.ToString();

            ddlNuevoEstado.SelectedValue = ticket.EstadoTicket.Id_EstadoTicket.ToString();
        }

        private void CargarHistorial()
        {
            // Necesitarás una clase HistorialNegocio.ListarPorTicket(int id)
            HistorialTicketsNegocio historialNegocio = new HistorialTicketsNegocio();
            rptHistorial.DataSource = historialNegocio.ListarPorTicket(int.Parse(lblTicketID.Text));
            rptHistorial.DataBind();
        }

        // Botón para actualizar el SLA
        protected void btnActualizarSLA_Click(object sender, EventArgs e)
        {
            try
            {
                TicketsNegocio negocio = new TicketsNegocio();
                negocio.ActualizarSLA(
                    int.Parse(lblTicketID.Text),
                    int.Parse(ddlSLA.SelectedValue)
                );
            }
            catch (Exception ex)
            {
                lblError.Text = "Error al actualizar SLA: " + ex.Message;
                lblError.Visible = true;
            }
        }

        // Botón para agregar comentario O cerrar ticket
        protected void btnActualizarTicket_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                TicketsNegocio negocio = new TicketsNegocio();
                negocio.ActualizarEstado(
                    int.Parse(lblTicketID.Text),
                    int.Parse(ddlNuevoEstado.SelectedValue),
                    tecnicoLogueado.Id_Empleado,
                    txtNuevoComentario.Text
                );

                // Recargar todo
                CargarDatosDelTicket();
                CargarDropDownLists();
                CargarHistorial();
                txtNuevoComentario.Text = ""; // Limpiar el comentario
            }
            catch (Exception ex)
            {
                lblError.Text = "Error al actualizar: " + ex.Message;
                lblError.Visible = true;
            }
        }
    }
}