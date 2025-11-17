using System;
using Dominio;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Negocio
{
    public class RolesNegocio
    {
        public List<Rol> Listar()
        {
            List<Rol> lista = new List<Rol>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.SetearConsulta("SELECT Id_Rol, NombreRol FROM Roles");
                datos.EjecutarLectura();
                while (datos.Lector.Read())
                {
                    Rol aux = new Rol();
                    aux.Id_Rol = (int)datos.Lector["Id_Rol"];
                    aux.NombreRol = (string)datos.Lector["NombreRol"];
                    lista.Add(aux);
                }

                return lista;
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
