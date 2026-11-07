// Formatos del Manual Maestro de PM y AA.II. (Anexo A). Las misiones pueden añadir/sobrescribir en description.ext.
class ADVSEC_ReportTypes {
    class FPM01 {
        code = "F-PM-01";
        dept = "PM";
        displayName = "$STR_ADVSEC_duty_report";
        hint = "$STR_ADVSEC_sop_pm_01_02_04";
    };
    class FPM02 {
        code = "F-PM-02";
        dept = "PM";
        displayName = "$STR_ADVSEC_complaint_or_grievance";
        hint = "$STR_ADVSEC_sop_pm_03_complainant_accused";
    };
    class FPM03 {
        code = "F-PM-03";
        dept = "PM";
        displayName = "$STR_ADVSEC_evidence_log_and_chain_of";
        hint = "$STR_ADVSEC_sop_ai_02_evidence_replay";
    };
    class FPM04 {
        code = "F-PM-04";
        dept = "PM";
        displayName = "$STR_ADVSEC_arrest_and_cell_admission_report";
        hint = "$STR_ADVSEC_identity_of_the_detainee_reason";
    };
    class FAI01 {
        code = "F-AI-01";
        dept = "AI";
        displayName = "$STR_ADVSEC_case_opening_order";
        hint = "$STR_ADVSEC_opening_2_days_appointment_of";
    };
    class FAI02 {
        code = "F-AI-02";
        dept = "AI";
        displayName = "$STR_ADVSEC_statement_record";
        hint = "$STR_ADVSEC_declarant_role_investigated_witness_comp";
    };
    class FAI03 {
        code = "F-AI-03";
        dept = "AI";
        displayName = "$STR_ADVSEC_statement_of_charges_and_summons";
        hint = "$STR_ADVSEC_alleged_facts_and_provisional_classifica";
    };
    class FAI04 {
        code = "F-AI-04";
        dept = "AI";
        displayName = "$STR_ADVSEC_hearing_record";
        hint = "$STR_ADVSEC_oral_presentation_before_ia_attendees";
    };
    class FAI05 {
        code = "F-AI-05";
        dept = "AI";
        displayName = "$STR_ADVSEC_proposed_resolution_and_resolution";
        hint = "$STR_ADVSEC_proven_facts_offence_sanction_levels";
    };
    class FAI06 {
        code = "F-AI-06";
        dept = "AI";
        displayName = "Recurso";
        hint = "$STR_ADVSEC_reconsideration_5_days_or_higher";
    };
    class FAI07 {
        code = "F-AI-07";
        dept = "AI";
        displayName = "$STR_ADVSEC_internal_affairs_quarterly_report";
        hint = "$STR_ADVSEC_summary_of_the_quarter_s";
    };
    class FPMC01 {
        code = "F-PMC-01";
        dept = "PM";
        displayName = "$STR_ADVSEC_pmc_rep_settle";
        hint = "$STR_ADVSEC_pmc_rep_settle_hint";
    };
    class FPMC02 {
        code = "F-PMC-02";
        dept = "PM";
        displayName = "$STR_ADVSEC_pmc_rep_audit";
        hint = "$STR_ADVSEC_pmc_rep_audit_hint";
    };
};

class ADVSEC_ReportLists {
    gravity[] = {"Leve", "Grave", "Muy grave"};
    status[] = {"Registrado", "Diligencias previas", "Remitido a AA.II.", "Expediente abierto", "Instrucción", "Pliego de cargos", "Descargos", "Audiencia", "Propuesta de resolución", "Resuelto", "Recurso", "Archivado"};
    sanction[] = {"Ninguna", "1 - Apercibimiento verbal", "2 - Apercibimiento escrito", "3 - Retirada de rol", "4 - Suspensión de operaciones", "5 - Expulsión"};
};
