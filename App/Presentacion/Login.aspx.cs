
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Negocio;
using Dominio;
using System;

namespace Presentacion
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Limpia mensaje en cada carga
            lblError.Visible = false;
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            UsuarioNegocio negocio = new UsuarioNegocio();

            // CAMBIO AQUÍ: La variable ahora es de tipo 'Empleado'
            Empleado usuario = negocio.Login(txtCorreo.Text, txtPassword.Text);

            if (usuario != null)
            {
                // Ahora guardas un 'Empleado' en la sesión
                Session["usuario"] = usuario;

                // Esta lógica sigue funcionando igual
                if (usuario.Rol.NombreRol == "Administrador")
                    Response.Redirect("Admin/Home.aspx");
                else
                    Response.Redirect("Home.aspx");
            }
            else
            {
                lblError.Text = "Correo o contraseña incorrectos.";
                lblError.Visible = true;
            }
        }
    }
}