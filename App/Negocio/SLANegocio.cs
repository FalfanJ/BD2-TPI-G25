using Dominio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Negocio
{
    public class SLANegocio
    {
        public List<SLA> Listar()
        {
            List<SLA> lista = new List<SLA>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.SetearConsulta("SELECT Id_SLA, Nivel FROM SLA");
                datos.EjecutarLectura();
                while (datos.Lector.Read())
                {
                    SLA aux = new SLA();
                    aux.Id_SLA = (int)datos.Lector["Id_SLA"];
                    aux.Nivel = (string)datos.Lector["Nivel"];
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
