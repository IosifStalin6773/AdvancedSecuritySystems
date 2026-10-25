// Formatos del Manual Maestro de PM y AA.II. (Anexo A). Las misiones pueden añadir/sobrescribir en description.ext.
class ADVSEC_ReportTypes {
    class FPM01 {
        code = "F-PM-01";
        dept = "PM";
        displayName = "Parte de novedades de servicio";
        hint = "SOP-PM-01/02/04. Plazo: 24 h. Servicio, incidencias, medidas inmediatas adoptadas.";
    };
    class FPM02 {
        code = "F-PM-02";
        dept = "PM";
        displayName = "Denuncia o queja";
        hint = "SOP-PM-03. Denunciante, denunciados, fecha/hora/lugar, hechos objetivos, evidencias y testigos, confidencialidad. Acuse 48 h, remisión a AI 24 h.";
    };
    class FPM03 {
        code = "F-PM-03";
        dept = "PM";
        displayName = "Registro de evidencias y cadena de custodia";
        hint = "SOP-AI-02. Evidencia (replay, log, captura), origen, hash, quién la entrega y quién la custodia.";
    };
    class FPM04 {
        code = "F-PM-04";
        dept = "PM";
        displayName = "Acta de detención e ingreso en calabozo";
        hint = "Identidad del detenido, motivo, agente actuante, tiempo de arresto, objetos intervenidos y estado al ingreso.";
    };
    class FAI01 {
        code = "F-AI-01";
        dept = "AI";
        displayName = "Providencia de apertura de expediente";
        hint = "Apertura (2 días), nombramiento de instructor y comunicación al Comandante.";
    };
    class FAI02 {
        code = "F-AI-02";
        dept = "AI";
        displayName = "Acta de declaración";
        hint = "Declarante, condición (investigado/testigo/denunciante), contenido de la declaración.";
    };
    class FAI03 {
        code = "F-AI-03";
        dept = "AI";
        displayName = "Pliego de cargos y citación";
        hint = "Hechos imputados y calificación provisional. Descargos: 5 días.";
    };
    class FAI04 {
        code = "F-AI-04";
        dept = "AI";
        displayName = "Acta de audiencia";
        hint = "Exposición oral ante AI, asistentes y alegaciones.";
    };
    class FAI05 {
        code = "F-AI-05";
        dept = "AI";
        displayName = "Propuesta de resolución y resolución";
        hint = "Hechos probados, infracción, sanción (niveles 1-5) y autoridad competente.";
    };
    class FAI06 {
        code = "F-AI-06";
        dept = "AI";
        displayName = "Recurso";
        hint = "Reposición (5 días) o alzada (7 días). Resolución recurrida y motivos.";
    };
    class FAI07 {
        code = "F-AI-07";
        dept = "AI";
        displayName = "Informe trimestral de Asuntos Internos";
        hint = "Resumen de expedientes del trimestre, sanciones y recomendaciones.";
    };
};

class ADVSEC_ReportLists {
    gravity[] = {"Leve", "Grave", "Muy grave"};
    status[] = {"Registrado", "Diligencias previas", "Remitido a AA.II.", "Expediente abierto", "Instrucción", "Pliego de cargos", "Descargos", "Audiencia", "Propuesta de resolución", "Resuelto", "Recurso", "Archivado"};
    sanction[] = {"Ninguna", "1 - Apercibimiento verbal", "2 - Apercibimiento escrito", "3 - Retirada de rol", "4 - Suspensión de operaciones", "5 - Expulsión"};
};
