using Dominio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Negocio
{
    public class TiposTicketsNegocio
    {
        public List<TiposTickets> Listar()
        {
            List<TiposTickets> lista = new List<TiposTickets>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.SetearConsulta("SELECT Id_TipoTicket, NombreTipo FROM TiposTickets");
                datos.EjecutarLectura();
                while (datos.Lector.Read())
                {
                    TiposTickets aux = new TiposTickets();
                    aux.Id_TipoTicket = (int)datos.Lector["Id_TipoTicket"];
                    aux.NombreTipo = (string)datos.Lector["NombreTipo"];
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
