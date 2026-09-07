const API_URL = "http://localhost:5019";

let vistaActual = "activas";
let peticionEnCurso = false;
let idEdicionActual = null;
let listaSolicitudesMemoria = [];

// Control de navegación para el Calendario de Preventivos
let mesActual = new Date().getMonth();
let anioActual = new Date().getFullYear();
const NOMBRES_MESES = [
  "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio",
  "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"
];

let filtroCategoriaActual = "Todas";

function aplicarFiltroCategoria() {
  const select = document.getElementById("filtro-categoria");
  if (select) {
    filtroCategoriaActual = select.value;
  }
  renderizarTabla();
}

function cambiarVista(vista) {
  vistaActual = vista;
  const btnActivas = document.getElementById("btn-activas");
  const btnHistorial = document.getElementById("btn-historial");
  const btnCalendario = document.getElementById("btn-calendario");
  const vistaTabla = document.getElementById("vista-tabla");
  const vistaCalendario = document.getElementById("vista-calendario");
  const contenedorFiltro = document.getElementById("contenedor-filtro-categoria");

  btnActivas.className = "boton-secundario";
  btnHistorial.className = "boton-secundario";
  if (btnCalendario) btnCalendario.className = "boton-secundario";

  if (contenedorFiltro) {
    if (vista === "calendario") {
      contenedorFiltro.classList.add("oculto");
    } else {
      contenedorFiltro.classList.remove("oculto");
    }
  }

  if (vista === "activas") {
    btnActivas.className = "boton-primario";
    vistaTabla.classList.remove("oculto");
    vistaCalendario.classList.add("oculto");
    cargarSolicitudes();
  } else if (vista === "historial") {
    btnHistorial.className = "boton-primario";
    vistaTabla.classList.remove("oculto");
    vistaCalendario.classList.add("oculto");
    cargarSolicitudes();
  } else if (vista === "calendario") {
    if (btnCalendario) btnCalendario.className = "boton-primario";
    vistaTabla.classList.add("oculto");
    vistaCalendario.classList.remove("oculto");
    renderizarCalendario();
  }
}

async function cargarSolicitudes() {
  try {
    const ruta = vistaActual === "activas" ? "/solicitudes/activas" : "/solicitudes/historial";
    const respuesta = await fetch(`${API_URL}${ruta}`);
    if (!respuesta.ok) throw new Error(`HTTP Error: ${respuesta.status}`);

    listaSolicitudesMemoria = await respuesta.json();
    renderizarTabla();
  } catch (error) {
    console.error("Error al cargar solicitudes:", error);
  }
}

function renderizarTabla() {
  const tabla = document.getElementById("cuerpo-tabla");
  if (!tabla) return;
  tabla.innerHTML = "";

  const solicitudesFiltradas = listaSolicitudesMemoria.filter(s => {
    if (filtroCategoriaActual === "Todas") return true;
    return s.categoria === filtroCategoriaActual;
  });

  if (solicitudesFiltradas.length === 0) {
    tabla.innerHTML = `<tr><td colspan="8" style="text-align: center; color: #9ca3af; padding: 24px;">No hay registros para mostrar con el filtro seleccionado.</td></tr>`;
    return;
  }

  solicitudesFiltradas.forEach(s => {
    const clasePrioridad = s.prioridad === 'Alta' ? 'badge-alta' : (s.prioridad === 'Media' ? 'badge-media' : 'badge-baja');
    const claseEstado = s.estado === 'En Proceso' ? 'badge-proceso' : (s.estado === 'Cerrado' ? 'badge-baja' : 'badge-pendiente');
    const claseCategoria = s.categoria === 'Preventivo' ? 'badge-preventivo' : 'badge-correctivo';

    // Trazabilidad de marcas de tiempo
    let infoFecha = `<div><span style="font-size:0.75rem; color:#64748b;">Reportado:</span> <strong>${s.fechaSolicitud}</strong></div>`;
    if (s.fechaAsignacion) {
      infoFecha += `<div style="margin-top: 2px;"><span style="font-size:0.75rem; color:#2563eb; font-weight:600;">Iniciado:</span> ${s.fechaAsignacion}</div>`;
    }
    if (s.fechaRealizacion) {
      infoFecha += `<div style="margin-top: 2px;"><span style="font-size:0.75rem; color:#059669; font-weight:600;">Terminado:</span> ${s.fechaRealizacion}</div>`;
    }
    if (s.categoria === 'Preventivo' && s.fechaProgramada) {
      infoFecha += `
        <div style="margin-top: 4px; padding-top: 3px; border-top: 1px dashed #cbd5e1;">
          <span style="font-size:0.75rem; color:#7c3aed; font-weight:700;">Próxima:</span> <strong>${s.fechaProgramada}</strong>
          <div style="font-size: 0.7rem; color: #64748b;">(${s.frecuencia || 'Única vez'})</div>
        </div>
      `;
    }

    let detalleTrabajo = `<div>${s.descripcion}</div>`;
    if (vistaActual === 'historial' && s.notaResolucion) {
      detalleTrabajo += `<div style="margin-top: 4px; font-size: 0.75rem; color: #059669; font-weight: 500;"><strong>Resolución:</strong> ${s.notaResolucion}</div>`;
    }

    tabla.innerHTML += `
      <tr>
        <td><strong>#${s.id}</strong></td>
        <td><span class="badge ${claseCategoria}">${s.categoria}</span></td>
        <td>${infoFecha}</td>
        <td>${s.areaEquipo}</td>
        <td>${detalleTrabajo}</td>
        <td><span class="badge ${clasePrioridad}">${s.prioridad}</span></td>
        <td><span class="badge ${claseEstado}">${s.estado}</span></td>
        <td class="texto-derecha">
          ${s.estado === 'Pendiente' ? `<button class="boton-accion btn-iniciar" onclick="actualizarEstado(${s.id}, 'En Proceso')">Iniciar</button>` : ''}
          ${s.estado === 'En Proceso' ? `<button class="boton-accion btn-cerrar" onclick="cerrarConNota(${s.id})">Cerrar</button>` : ''}
          <button class="boton-accion btn-editar" onclick="abrirModalEdicion(${s.id})">Editar</button>
          <button class="boton-accion btn-eliminar" onclick="eliminarSolicitud(${s.id})">Borrar</button>
        </td>
      </tr>
    `;
  });
}

// ----------------- CALENDARIO / AGENDA DE PREVENTIVOS -----------------
function navegarMes(delta) {
  mesActual += delta;
  if (mesActual < 0) {
    mesActual = 11;
    anioActual--;
  } else if (mesActual > 11) {
    mesActual = 0;
    anioActual++;
  }
  renderizarCalendario();
}

async function renderizarCalendario() {
  document.getElementById("titulo-mes").innerText = `${NOMBRES_MESES[mesActual]} ${anioActual}`;
  const contenedorDias = document.getElementById("dias-calendario");
  contenedorDias.innerHTML = '<div style="grid-column: span 7; text-align: center; padding: 24px; color: #94a3b8;">Cargando tareas programadas...</div>';

  try {
    const res = await fetch(`${API_URL}/solicitudes/activas`);
    if (!res.ok) throw new Error("Error al obtener solicitudes para el calendario");
    const solicitudes = await res.json();

    // Filtrar mantenimientos preventivos que tengan fecha programada
    const preventivos = solicitudes.filter(s => s.categoria === "Preventivo" && s.fechaProgramada);

    contenedorDias.innerHTML = "";

    const primerDiaMes = new Date(anioActual, mesActual, 1);
    const diasEnMes = new Date(anioActual, mesActual + 1, 0).getDate();
    const diasMesAnterior = new Date(anioActual, mesActual, 0).getDate();

    // Lunes = 0, Domingo = 6
    const indiceInicio = (primerDiaMes.getDay() + 6) % 7;

    const hoy = new Date();
    const esMesActual = hoy.getFullYear() === anioActual && hoy.getMonth() === mesActual;

    // Relleno mes anterior
    for (let i = indiceInicio - 1; i >= 0; i--) {
      const diaNum = diasMesAnterior - i;
      const celda = document.createElement("div");
      celda.className = "celda-dia otro-mes";
      celda.innerHTML = `<span class="numero-dia">${diaNum}</span>`;
      contenedorDias.appendChild(celda);
    }

    // Días del mes en curso
    for (let dia = 1; dia <= diasEnMes; dia++) {
      const celda = document.createElement("div");
      const esHoy = esMesActual && hoy.getDate() === dia;
      celda.className = `celda-dia ${esHoy ? "hoy" : ""}`;

      const diaStr = String(dia).padStart(2, "0");
      const mesStr = String(mesActual + 1).padStart(2, "0");
      const fechaISO = `${anioActual}-${mesStr}-${diaStr}`;

      celda.innerHTML = `<span class="numero-dia">${dia}</span>`;

      // Preventivos programados en esta fecha
      const tareasDelDia = preventivos.filter(s => s.fechaProgramada === fechaISO);
      tareasDelDia.forEach(t => {
        const item = document.createElement("div");
        const claseColor = t.prioridad === "Alta" ? "evento-alta" : (t.prioridad === "Media" ? "evento-media" : "evento-baja");
        item.className = `evento-tarea ${claseColor}`;
        item.title = `#${t.id} - ${t.areaEquipo}: ${t.descripcion} (${t.frecuencia || 'Única vez'})`;
        item.innerText = `#${t.id} ${t.areaEquipo} - ${t.descripcion}`;
        item.onclick = () => {
          alert(`Mantenimiento Preventivo #${t.id}\n` +
                `Área: ${t.areaEquipo}\n` +
                `Descripción: ${t.descripcion}\n` +
                `Prioridad: ${t.prioridad}\n` +
                `Frecuencia: ${t.frecuencia || 'Única vez'}\n` +
                `Estado: ${t.estado}\n` +
                `Fecha Programada: ${t.fechaProgramada}`);
        };
        celda.appendChild(item);
      });

      contenedorDias.appendChild(celda);
    }

    // Relleno mes siguiente
    const totalCeldas = indiceInicio + diasEnMes;
    const celdasRestantes = (7 - (totalCeldas % 7)) % 7;
    for (let j = 1; j <= celdasRestantes; j++) {
      const celda = document.createElement("div");
      celda.className = "celda-dia otro-mes";
      celda.innerHTML = `<span class="numero-dia">${j}</span>`;
      contenedorDias.appendChild(celda);
    }

  } catch (error) {
    console.error("Error al renderizar calendario:", error);
    contenedorDias.innerHTML = '<div style="grid-column: span 7; text-align: center; padding: 24px; color: #ef4444;">Error al cargar las tareas en el calendario.</div>';
  }
}

function abrirModalEdicion(id) {
  const solicitud = listaSolicitudesMemoria.find(s => s.id === id);
  if (!solicitud) return;

  idEdicionActual = id;
  document.querySelector("#modal-reporte h3").innerText = `Editar Reporte #${id}`;
  document.querySelector("#formulario-solicitud button[type='submit']").innerText = "Guardar Cambios";

  document.getElementById("categoria").value = solicitud.categoria;
  document.getElementById("prioridad").value = solicitud.prioridad;
  document.getElementById("descripcion").value = solicitud.descripcion;
  if (document.getElementById("idTecnicoAsignado")) {
    document.getElementById("idTecnicoAsignado").value = solicitud.idTecnicoAsignado || 1;
  }

  const seccionPrev = document.getElementById("seccion-preventivo");
  const inputFecha = document.getElementById("fechaProgramada");

  if (solicitud.categoria === "Preventivo") {
    seccionPrev.classList.remove("oculto");
    inputFecha.required = true;
    inputFecha.value = solicitud.fechaProgramada || "";
    document.getElementById("frecuencia").value = solicitud.frecuencia || "Mensual (cada 1 mes)";
  } else {
    seccionPrev.classList.add("oculto");
    inputFecha.required = false;
    inputFecha.value = "";
  }

  document.getElementById("modal-reporte").classList.remove("oculto");
}

async function eliminarSolicitud(id) {
  if (!confirm(`¿Está segura de que desea eliminar el reporte #${id}? Esta acción no se puede deshacer.`)) {
    return;
  }

  try {
    const respuesta = await fetch(`${API_URL}/solicitudes/${id}`, {
      method: "DELETE"
    });

    if (respuesta.ok) {
      if (vistaActual === "calendario") {
        renderizarCalendario();
      } else {
        cargarSolicitudes();
      }
    } else {
      alert("No se pudo eliminar el reporte.");
    }
  } catch (error) {
    console.error("Error al eliminar solicitud:", error);
  }
}

async function actualizarEstado(id, nuevoEstado, notaResolucion = null) {
  try {
    const res = await fetch(`${API_URL}/solicitudes/${id}/estado`, {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ nuevoEstado: nuevoEstado, notaResolucion: notaResolucion })
    });
    if (!res.ok) throw new Error("Error en la respuesta del servidor");

    const data = await res.json();
    if (data.Mensaje) {
      alert(data.Mensaje);
    }

    if (vistaActual === "calendario") {
      renderizarCalendario();
    } else {
      cargarSolicitudes();
    }
  } catch (error) {
    console.error("Error al actualizar estado:", error);
  }
}

function cerrarConNota(id) {
  const nota = prompt("Ingrese nota u observaciones de cierre:");
  if (nota !== null) {
    actualizarEstado(id, "Cerrado", nota.trim() === "" ? "Finalizado sin observaciones" : nota.trim());
  }
}

document.getElementById("categoria").addEventListener("change", (e) => {
  const seccion = document.getElementById("seccion-preventivo");
  const inputFecha = document.getElementById("fechaProgramada");
  if (e.target.value === "Preventivo") {
    seccion.classList.remove("oculto");
    inputFecha.required = true;
  } else {
    seccion.classList.add("oculto");
    inputFecha.required = false;
    inputFecha.value = "";
  }
});

// Manejo unificado de Guardar (Creación o Edición)
document.getElementById("formulario-solicitud").addEventListener("submit", async function(evento) {
  evento.preventDefault();

  if (peticionEnCurso) return;
  peticionEnCurso = true;

  const botonGuardar = this.querySelector("button[type='submit']");
  if (botonGuardar) {
    botonGuardar.disabled = true;
    botonGuardar.innerText = "Guardando...";
  }

  const idAreaVal = document.getElementById("idAreaEquipo").value;
  const idTecnicoVal = document.getElementById("idTecnicoAsignado") ? document.getElementById("idTecnicoAsignado").value : "1";
  const esPreventivo = document.getElementById("categoria").value === "Preventivo";

  const payload = {
    descripcion: document.getElementById("descripcion").value,
    prioridad: document.getElementById("prioridad").value,
    categoria: document.getElementById("categoria").value,
    idAreaEquipo: idAreaVal ? parseInt(idAreaVal) : null,
    fechaProgramada: esPreventivo ? (document.getElementById("fechaProgramada").value || null) : null,
    frecuencia: esPreventivo ? document.getElementById("frecuencia").value : null,
    idTecnicoAsignado: idTecnicoVal ? parseInt(idTecnicoVal) : 1
  };

  try {
    let url = `${API_URL}/solicitudes`;
    let metodo = "POST";

    if (idEdicionActual) {
      url = `${API_URL}/solicitudes/${idEdicionActual}`;
      metodo = "PUT";
    } else {
      payload.estado = "Pendiente";
    }

    const respuesta = await fetch(url, {
      method: metodo,
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload)
    });

    if (respuesta.ok) {
      cerrarModal();
      if (vistaActual === "calendario") {
        renderizarCalendario();
      } else {
        cargarSolicitudes();
      }
    }
  } catch (error) {
    console.error("Error al procesar solicitud:", error);
  } finally {
    peticionEnCurso = false;
    if (botonGuardar) {
      botonGuardar.disabled = false;
      botonGuardar.innerText = idEdicionActual ? "Guardar Cambios" : "Guardar Reporte";
    }
  }
});

function abrirModal() {
  idEdicionActual = null;
  document.querySelector("#modal-reporte h3").innerText = "Nuevo Reporte de Falla";
  document.querySelector("#formulario-solicitud button[type='submit']").innerText = "Guardar Reporte";
  document.getElementById("formulario-solicitud").reset();
  document.getElementById("seccion-preventivo").classList.add("oculto");
  document.getElementById("modal-reporte").classList.remove("oculto");
}

function cerrarModal() {
  idEdicionActual = null;
  document.getElementById("formulario-solicitud").reset();
  document.getElementById("modal-reporte").classList.add("oculto");
}

cambiarVista("activas");