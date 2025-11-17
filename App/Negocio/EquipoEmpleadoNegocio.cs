using Dominio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Negocio
{
    public class EquipoEmpleadoNegocio
    {
        public List<EquipoEmpleado> Listar()
        {
            List<EquipoEmpleado> lista = new List<EquipoEmpleado>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.SetearConsulta("SELECT Id_Empleado, Id_Equipo FROM EquipoEmpleado");
                datos.EjecutarLectura();
                while (datos.Lector.Read())
                {
                    EquipoEmpleado aux = new EquipoEmpleado();
                    aux.Empleado = new Empleado();
                    aux.Equipo = new Equipo();
                    aux.Empleado.Id_Empleado = (int)datos.Lector["Id_Empleado"];
                    aux.Equipo.Id_Equipo = (int)datos.Lector["Id_Equipo"];
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
