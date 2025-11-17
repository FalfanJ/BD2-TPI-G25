using Dominio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Negocio
{
    public class EstadosTicketNegocio
    {
        public List<EstadosTicket> Listar()
        {
            List<EstadosTicket> lista = new List<EstadosTicket>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.SetearConsulta("SELECT Id_EstadoTicket, NombreEstado FROM EstadosTicket");
                datos.EjecutarLectura();
                while (datos.Lector.Read())
                {
                    EstadosTicket aux = new EstadosTicket();
                    aux.Id_EstadoTicket = (int)datos.Lector["Id_EstadoTicket"];
                    aux.NombreEstado = (string)datos.Lector["NombreEstado"];
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
