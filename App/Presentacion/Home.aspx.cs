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
    public partial class Home : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // 1. VERIFICACIÓN DE SEGURIDAD
            if (Session["usuario"] == null)
            {
                Response.Redirect("Login.aspx", false);
            }

           
            Empleado usuarioLogueado = (Empleado)Session["usuario"];

            if (!IsPostBack)
            {
                // Mostramos el nombre del usuario logueado
                lblNombreUsuario.Text = usuarioLogueado.Nombre + " " + usuarioLogueado.Apellido;

                // 2. LÓGICA DE ROLES
                if (usuarioLogueado.Rol.NombreRol == "Cliente")
                {
                    pnlCliente.Visible = true;
                    pnlTecnico.Visible = false;
                    CargarMisTickets(usuarioLogueado.Id_Empleado);
                }
                else if (usuarioLogueado.Rol.NombreRol == "Tecnico")
                {
                    pnlCliente.Visible = false;
                    pnlTecnico.Visible = true;
                    CargarGrillasTecnico(usuarioLogueado.Id_Empleado);
                }
                else if (usuarioLogueado.Rol.NombreRol == "Administrador")
                {
                    Response.Redirect("Admin/HomeAdmin.aspx", false);
                }
            }
        }

        // --- MÉTODOS PARA CLIENTE ---
        private void CargarMisTickets(int idCliente)
        {
            TicketsNegocio negocio = new TicketsNegocio();
            gvMisTickets.DataSource = negocio.ListarMisTickets(idCliente);
            gvMisTickets.DataBind();
        }

        // --- MÉTODOS PARA TECNICO ---
        private void CargarGrillasTecnico(int idTecnico)
        {
            // Llenamos las 4 grillas del técnico
            TicketsNegocio ticketNegocio = new TicketsNegocio();
            BaseDeConocimientoNegocio bcNegocio = new BaseDeConocimientoNegocio();
            EquipoNegocio equipoNegocio = new EquipoNegocio();

            // 1. Tickets Asignados a mí
            gvTicketsAsignados.DataSource = ticketNegocio.ListarMisTicketsAsignados(idTecnico);
            gvTicketsAsignados.DataBind();

            // 2. Tickets Sin Asignar
            gvTicketsSinAsignar.DataSource = ticketNegocio.ListarTicketsSinAsignar();
            gvTicketsSinAsignar.DataBind();

            // 3. Base de Conocimiento
            gvBaseConocimiento.DataSource = bcNegocio.Listar(); // Usamos el Listar() que optimizamos
            gvBaseConocimiento.DataBind();

            // 4. Inventario de Equipos
            gvInventario.DataSource = equipoNegocio.Listar(); // Usamos el Listar() que optimizamos
            gvInventario.DataBind();
        }

        // --- BOTONES ---
        protected void btnIrACrearTicket_Click(object sender, EventArgs e)
        {
            // Ambos roles usan la misma página para crear tickets
            Response.Redirect("CrearTicket.aspx", false);
        }
    }
}