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
    public partial class CrearTicket : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // 1. Validar Sesión
            if (Session["usuario"] == null)
            {
                Response.Redirect("Login.aspx", false);
            }

            if (!IsPostBack)
            {
                // 2. Cargar los DropDownLists
                Empleado usuarioLogueado = (Empleado)Session["usuario"];

                // Cargar los equipos del cliente logueado
                EquipoNegocio equipoNegocio = new EquipoNegocio();
                ddlEquipos.DataSource = equipoNegocio.ListarPorCliente(usuarioLogueado.Id_Empleado);
                ddlEquipos.DataValueField = "Id_Equipo";
                ddlEquipos.DataTextField = "Nombre";
                ddlEquipos.DataBind();

                // Cargar los tipos de ticket (Incidente, Requerimiento)
                TiposTicketsNegocio tipoNegocio = new TiposTicketsNegocio();
                ddlTiposTicket.DataSource = tipoNegocio.Listar();
                ddlTiposTicket.DataValueField = "Id_TipoTicket";
                ddlTiposTicket.DataTextField = "NombreTipo";
                ddlTiposTicket.DataBind();
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            try
            {
                // 3. Crear el objeto Tickets
                Tickets nuevoTicket = new Tickets();
                nuevoTicket.Cliente = (Empleado)Session["usuario"];

                nuevoTicket.Titulos = txtTitulo.Text;
                nuevoTicket.Descripcion = txtDescripcion.Text;

                nuevoTicket.Equipo = new Equipo();
                nuevoTicket.Equipo.Id_Equipo = int.Parse(ddlEquipos.SelectedValue);

                nuevoTicket.TipoTicket = new TiposTickets();
                nuevoTicket.TipoTicket.Id_TipoTicket = int.Parse(ddlTiposTicket.SelectedValue);

                // 4. Mandar a guardar en la DB
                TicketsNegocio negocio = new TicketsNegocio();
                negocio.Agregar(nuevoTicket);

                // 5. Redirigir al Home
                Response.Redirect("Home.aspx", false);
            }
            catch (Exception ex)
            {
                lblMensaje.Text = "Error al guardar el ticket: " + ex.Message;
                lblMensaje.CssClass = "text-danger";
                lblMensaje.Visible = true;
            }
        }
    }
}