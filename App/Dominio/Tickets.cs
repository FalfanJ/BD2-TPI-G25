using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dominio
{
    public class Tickets
    {
        public int Id_Ticket { get; set; }
        public string Titulos { get; set; }
        public DateTime Fecha { get; set; }
        public Empleado Cliente { get; set; }
        public Empleado Tecnico { get; set; }
        public Equipo Equipo { get; set; }
        public TiposTickets TipoTicket { get; set; }
        public EstadosTicket EstadoTicket { get; set; }
        public SLA SLA { get; set; }
        public GruposSoporte GrupoAsignado { get; set; }
        public string Descripcion { get; set; }
    }
}
