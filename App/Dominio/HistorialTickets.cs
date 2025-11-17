using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dominio
{
    public class HistorialTickets
    {
        public int Id_Historial { get; set; }
        public Tickets Ticket { get; set; }
        public DateTime? FechaModificacion { get; set; }
        public Empleado Modificado_Por { get; set; }
        public EstadosTicket EstadoTicket { get; set; }
        public string Descripcion { get; set; }
    }
}
