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
    public partial class VerArticulo : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            
            if (Session["usuario"] == null)
            {
                Response.Redirect("Login.aspx", false);
                return;
            }

            if (Request.QueryString["id"] == null)
            {
                Response.Redirect("Home.aspx", false);
                return;
            }

            if (!IsPostBack)
            {
                CargarArticulo();
            }
        }

        private void CargarArticulo()
        {
            try
            {
                long idArticulo = long.Parse(Request.QueryString["id"]);

                BaseDeConocimientoNegocio negocio = new BaseDeConocimientoNegocio();
                BaseDeConocimiento articulo = negocio.ObtenerPorId(idArticulo);

                if (articulo != null)
                {
                    litTitulo.Text = articulo.Titulo;
                    litAutor.Text = articulo.Autor.Nombre + " " + articulo.Autor.Apellido;
                    litSolucion.Text = articulo.Solucion.Replace("\n", "<br />");
                }
                else
                {
                    Response.Redirect("Home.aspx", false);
                }
            }
            catch (Exception)
            {
                Response.Redirect("Home.aspx", false);
            }
        }
    }
}