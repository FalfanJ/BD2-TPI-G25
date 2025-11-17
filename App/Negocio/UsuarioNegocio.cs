using System;
using Dominio;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Security.Cryptography;
using System.Threading.Tasks;

namespace Negocio
{
    public class UsuarioNegocio
    {
        // Este es el método de login corregido
        public Empleado Login(string email, string password)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                // 1. Llamamos al SP que valida Y DEVUELVE LOS DATOS
                datos.SetearProcedimiento("sp_ValidarUsuario");
                datos.SetearParametro("@Correo", email);
                datos.SetearParametro("@Password", password);
                datos.EjecutarLectura();

                // 2. Si trae una fila, el login fue exitoso
                if (datos.Lector.Read())
                {
                    // 3. Creamos un objeto EMPLEADO, no Usuario
                    Empleado usuarioLogueado = new Empleado();
                    usuarioLogueado.Id_Empleado = (int)datos.Lector["Id_Empleado"];
                    usuarioLogueado.Nombre = (string)datos.Lector["Nombre"];
                    usuarioLogueado.Apellido = (string)datos.Lector["Apellido"];
                    usuarioLogueado.Correo = (string)datos.Lector["Correo"];

                    // 4. Creamos su objeto ROL anidado
                    usuarioLogueado.Rol = new Rol();
                    usuarioLogueado.Rol.Id_Rol = (int)datos.Lector["Id_Rol"];
                    usuarioLogueado.Rol.NombreRol = (string)datos.Lector["NombreRol"]; // Leemos el NombreRol

                    return usuarioLogueado;
                }
                else
                {
                    // Si no trae filas, el login falló
                    return null;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datos.CerrarConexion();
            }
        }
    }
}
