using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Dominio; 

namespace Presentacion
{
    public partial class SiteMaster : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        
            if (Page.GetType().Name.ToLower() == "login_aspx")
            {
                phAdmin.Visible = false;
                phUser.Visible = false;
                return; 
            }

           
            Empleado user = Session["usuario"] as Empleado;

            if (user == null)
            {
                
                Response.Redirect("Login.aspx");
            }
            else
            {
               
                lblUsuario.Text = user.Correo;
                phUser.Visible = true;

                phAdmin.Visible = user.Rol.NombreRol == "Administrador";
            }


        }
    }
}