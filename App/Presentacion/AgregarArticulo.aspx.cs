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
    public partial class CrearArticulo : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Seguridad: Validar que sea Técnico o Admin
            if (Session["usuario"] == null)
            {
                Response.Redirect("Login.aspx", false);
                return;
            }

            Empleado usuarioLogueado = (Empleado)Session["usuario"];
            if (usuarioLogueado.Rol.NombreRol != "Tecnico" && usuarioLogueado.Rol.NombreRol != "Administrador")
            {
                Response.Redirect("Home.aspx", false); // No tiene permisos
                return;
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                BaseDeConocimientoNegocio negocio = new BaseDeConocimientoNegocio();
                BaseDeConocimiento nuevoArticulo = new BaseDeConocimiento();

                nuevoArticulo.Titulo = txtTitulo.Text;
                nuevoArticulo.Solucion = txtSolucion.Text;
                nuevoArticulo.Autor = (Empleado)Session["usuario"]; // Asignamos el autor logueado

                // Necesitamos un método 'Agregar' en el Negocio
                negocio.Agregar(nuevoArticulo);

                Response.Redirect("Home.aspx", false);
            }
            catch (Exception ex)
            {
                lblError.Text = "Error al guardar el artículo: " + ex.Message;
                lblError.Visible = true;
            }
        }
    }
}