using Dominio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Negocio
{
    public class EmpleadoNegocio
    {
        public List<Empleado> Listar()
        {
            List<Empleado> lista = new List<Empleado>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.SetearConsulta(@"SELECT Id_Empleado, Nombre, Apellido, Id_Ubicacion, 
                                       Correo, Telefono, Id_Rol FROM Empleado");

                datos.EjecutarLectura();
                while (datos.Lector.Read())
                {
                    Empleado aux = new Empleado();
                    aux.Ubicacion = new Ubicacion();
                    aux.Rol = new Rol();
                    aux.Id_Empleado = (int)datos.Lector["Id_Empleado"];
                    aux.Nombre = (string)datos.Lector["Nombre"];
                    aux.Apellido = (string)datos.Lector["Apellido"];
                    aux.Ubicacion.Id_Ubicacion = (int)datos.Lector["Id_Ubicacion"];
                    aux.Correo = datos.Lector["Correo"] as string;
                    aux.Telefono = datos.Lector["Telefono"] as int?;
                    aux.Rol.Id_Rol = (int)datos.Lector["Id_Rol"];

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
