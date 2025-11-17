using Dominio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Negocio
{
    public class GruposSoporteNegocio
    {
        public List<GruposSoporte> Listar()
        {
            List<GruposSoporte> lista = new List<GruposSoporte>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.SetearConsulta("SELECT Id_Grupo, NombreGrupo FROM GruposSoporte");
                datos.EjecutarLectura();
                while (datos.Lector.Read())
                {
                    GruposSoporte aux = new GruposSoporte();
                    aux.Id_Grupo = (int)datos.Lector["Id_Grupo"];
                    aux.NombreGrupo = (string)datos.Lector["NombreGrupo"];
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
