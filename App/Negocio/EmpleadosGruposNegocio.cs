using Dominio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Negocio
{
    public class EmpleadosGruposNegocio
    {
        public List<EmpleadosGrupos> Listar()
        {
            List<EmpleadosGrupos> lista = new List<EmpleadosGrupos>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.SetearConsulta("SELECT Id_Empleado, Id_Grupo FROM EmpleadosGrupos");
                datos.EjecutarLectura();
                while (datos.Lector.Read())
                {
                    EmpleadosGrupos aux = new EmpleadosGrupos();
                    aux.Empleado = new Empleado();
                    aux.Grupo = new GruposSoporte();
                    aux.Empleado.Id_Empleado = (int)datos.Lector["Id_Empleado"];
                    aux.Grupo.Id_Grupo = (int)datos.Lector["Id_Grupo"];
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
