CLASS LHC_RAP_TDAT_CTS DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS:
      GET
        RETURNING
          VALUE(RESULT) TYPE REF TO IF_MBC_CP_RAP_TDAT_CTS.

ENDCLASS.

CLASS LHC_RAP_TDAT_CTS IMPLEMENTATION.
  METHOD GET.
    result = mbc_cp_api=>rap_tdat_cts( tdat_name = 'ZERRORCODE010'
                                       table_entity_relations = VALUE #(
                                         ( entity = 'ErrorCode010' table = 'ZERRCODE_010' )
                                         ( entity = 'ErrorCode010Text' table = 'ZERRCODET_010' )
                                       ) ) ##NO_TEXT.
  ENDMETHOD.
ENDCLASS.
CLASS LHC_ZI_ERRORCODE010_S DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR ErrorCode010All
        RESULT result,
      SELECTCUSTOMIZINGTRANSPTREQ FOR MODIFY
        IMPORTING
          KEYS FOR ACTION ErrorCode010All~SelectCustomizingTransptReq
        RESULT result,
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR ErrorCode010All
        RESULT result.
ENDCLASS.

CLASS LHC_ZI_ERRORCODE010_S IMPLEMENTATION.
  METHOD GET_INSTANCE_FEATURES.
    DATA: selecttransport_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled,
          edit_flag            TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.

    IF lhc_rap_tdat_cts=>get( )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    IF lhc_rap_tdat_cts=>get( )->is_transport_allowed( ) = abap_false.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    READ ENTITIES OF ZI_ErrorCode010_S IN LOCAL MODE
    ENTITY ErrorCode010All
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(all).
    IF all[ 1 ]-%IS_DRAFT = if_abap_behv=>mk-off.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result = VALUE #( (
               %TKY = all[ 1 ]-%TKY
               %ACTION-edit = edit_flag
               %ASSOC-_ErrorCode010 = edit_flag
               %ACTION-SelectCustomizingTransptReq = selecttransport_flag ) ).
  ENDMETHOD.
  METHOD SELECTCUSTOMIZINGTRANSPTREQ.
    MODIFY ENTITIES OF ZI_ErrorCode010_S IN LOCAL MODE
      ENTITY ErrorCode010All
        UPDATE FIELDS ( TransportRequestID HideTransport )
        WITH VALUE #( FOR key IN keys
                        ( %TKY               = key-%TKY
                          TransportRequestID = key-%PARAM-transportrequestid
                          HideTransport      = abap_false ) ).

    READ ENTITIES OF ZI_ErrorCode010_S IN LOCAL MODE
      ENTITY ErrorCode010All
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(entities).
    result = VALUE #( FOR entity IN entities
                        ( %TKY   = entity-%TKY
                          %PARAM = entity ) ).
  ENDMETHOD.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD 'ZI_ERRORCODE010' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%UPDATE      = is_authorized.
    result-%ACTION-Edit = is_authorized.
    result-%ACTION-SelectCustomizingTransptReq = is_authorized.
  ENDMETHOD.
ENDCLASS.
CLASS LSC_ZI_ERRORCODE010_S DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_SAVER.
  PROTECTED SECTION.
    METHODS:
      SAVE_MODIFIED REDEFINITION,
      CLEANUP_FINALIZE REDEFINITION.
ENDCLASS.

CLASS LSC_ZI_ERRORCODE010_S IMPLEMENTATION.
  METHOD SAVE_MODIFIED.
    READ TABLE update-ErrorCode010All INDEX 1 INTO DATA(all).
    IF all-TransportRequestID IS NOT INITIAL.
      lhc_rap_tdat_cts=>get( )->record_changes(
                                  transport_request = all-TransportRequestID
                                  create            = REF #( create )
                                  update            = REF #( update )
                                  delete            = REF #( delete ) ).
    ENDIF.
  ENDMETHOD.
  METHOD CLEANUP_FINALIZE ##NEEDED.
  ENDMETHOD.
ENDCLASS.
CLASS LHC_ZI_ERRORCODE010TEXT DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_FEATURES FOR GLOBAL FEATURES
        IMPORTING
          REQUEST REQUESTED_FEATURES FOR ErrorCode010Text
        RESULT result.
ENDCLASS.

CLASS LHC_ZI_ERRORCODE010TEXT IMPLEMENTATION.
  METHOD GET_GLOBAL_FEATURES.
    DATA edit_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.
    IF lhc_rap_tdat_cts=>get( )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result-%UPDATE = edit_flag.
    result-%DELETE = edit_flag.
  ENDMETHOD.
ENDCLASS.
CLASS LHC_ZI_ERRORCODE010 DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      VALIDATEDATACONSISTENCY FOR VALIDATE ON SAVE
        IMPORTING
          KEYS FOR ErrorCode010~ValidateDataConsistency,
      GET_GLOBAL_FEATURES FOR GLOBAL FEATURES
        IMPORTING
          REQUEST REQUESTED_FEATURES FOR ErrorCode010
        RESULT result,
      DEPRECATE FOR MODIFY
        IMPORTING
          KEYS FOR ACTION ErrorCode010~Deprecate
        RESULT result,
      INVALIDATE FOR MODIFY
        IMPORTING
          KEYS FOR ACTION ErrorCode010~Invalidate
        RESULT result,
      COPYERRORCODE010 FOR MODIFY
        IMPORTING
          KEYS FOR ACTION ErrorCode010~CopyErrorCode010,
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR ErrorCode010
        RESULT result,
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR ErrorCode010
        RESULT result,
      VALIDATETRANSPORTREQUEST FOR VALIDATE ON SAVE
        IMPORTING
          KEYS_ERRORCODE010 FOR ErrorCode010~ValidateTransportRequest
          KEYS_ERRORCODE010TEXT FOR ErrorCode010Text~ValidateTransportRequest.
ENDCLASS.

CLASS LHC_ZI_ERRORCODE010 IMPLEMENTATION.
  METHOD VALIDATEDATACONSISTENCY.
    READ ENTITIES OF ZI_ErrorCode010_S IN LOCAL MODE
      ENTITY ErrorCode010
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(ErrorCode010).
    DATA(table) = xco_cp_abap_repository=>object->tabl->database_table->for( 'ZERRCODE_010' ).
    DATA: BEGIN OF element_check,
            element  TYPE string,
            check    TYPE REF TO if_xco_dp_check,
          END OF element_check,
          element_checks LIKE TABLE OF element_check WITH EMPTY KEY.
    LOOP AT ErrorCode010 ASSIGNING FIELD-SYMBOL(<ErrorCode010>).
      element_checks = VALUE #(
        ( element = 'ConfigDeprecationCode' check = table->field( 'CONFIGDEPRECATIONCODE' )->get_value_check( ia_value = <ErrorCode010>-ConfigDeprecationCode  ) )
      ).
      LOOP AT element_checks INTO element_check.
        INSERT VALUE #( %TKY        = <ErrorCode010>-%TKY
                        %STATE_AREA = |ErrorCode010_{ element_check-element }| ) INTO TABLE reported-ErrorCode010.
        element_check-check->execute( ).
        CHECK element_check-check->passed = xco_cp=>boolean->false.
        INSERT VALUE #( %TKY        = <ErrorCode010>-%TKY ) INTO TABLE failed-ErrorCode010.
        LOOP AT element_check-check->messages ASSIGNING FIELD-SYMBOL(<msg>).
          INSERT VALUE #( %TKY = <ErrorCode010>-%TKY
                          %STATE_AREA = |ErrorCode010_{ element_check-element }|
                          %PATH-ErrorCode010All-SingletonID = 1
                          %PATH-ErrorCode010All-%IS_DRAFT = <ErrorCode010>-%IS_DRAFT
                          %msg = mbc_cp_api=>message( )->get_behv_msg_from_value_check( <msg> ) ) INTO TABLE reported-ErrorCode010 ASSIGNING FIELD-SYMBOL(<rep>).
          ASSIGN COMPONENT element_check-element OF STRUCTURE <rep>-%ELEMENT TO FIELD-SYMBOL(<comp>).
          <comp> = if_abap_behv=>mk-on.
        ENDLOOP.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.
  METHOD GET_GLOBAL_FEATURES.
    DATA edit_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.
    IF lhc_rap_tdat_cts=>get( )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result-%UPDATE = edit_flag.
    result-%ASSOC-_ErrorCode010Text = edit_flag.
  ENDMETHOD.
  METHOD DEPRECATE.
    MODIFY ENTITIES OF ZI_ErrorCode010_S IN LOCAL MODE
      ENTITY ErrorCode010
      UPDATE
        FIELDS ( ConfigDeprecationCode ConfigDeprecationCode_Critlty )
        WITH VALUE #( FOR key IN keys
                       ( %TKY            = key-%TKY
                         ConfigDeprecationCode            = 'W'
                         ConfigDeprecationCode_Critlty = 2 ) ).
    READ ENTITIES OF ZI_ErrorCode010_S IN LOCAL MODE
      ENTITY ErrorCode010
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(ErrorCode010).
    result = VALUE #( FOR row IN ErrorCode010
                        ( %TKY   = row-%TKY
                          %PARAM  = row ) ).
    reported-ErrorCode010 = VALUE #( FOR key IN keys ( %CID = key-%CID_REF
                                                   %TKY = key-%TKY
                                                   %ACTION-Deprecate = if_abap_behv=>mk-on
                                                   %ELEMENT-ConfigDeprecationCode = if_abap_behv=>mk-on
                                                   %msg = mbc_cp_api=>message( )->get_item_deprecated( )
                                                   %PATH-ErrorCode010All-%IS_DRAFT = key-%IS_DRAFT
                                                   %PATH-ErrorCode010All-SingletonID = 1
          ) ).
  ENDMETHOD.
  METHOD INVALIDATE.
    MODIFY ENTITIES OF ZI_ErrorCode010_S IN LOCAL MODE
      ENTITY ErrorCode010
      UPDATE
        FIELDS ( ConfigDeprecationCode ConfigDeprecationCode_Critlty )
        WITH VALUE #( FOR key IN keys
                       ( %TKY            = key-%TKY
                         ConfigDeprecationCode            = 'E'
                         ConfigDeprecationCode_Critlty = 1 ) ).
    READ ENTITIES OF ZI_ErrorCode010_S IN LOCAL MODE
      ENTITY ErrorCode010
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(ErrorCode010).
    result = VALUE #( FOR row IN ErrorCode010
                        ( %TKY   = row-%TKY
                          %PARAM  = row ) ).
    reported-ErrorCode010 = VALUE #( FOR key IN keys ( %CID = key-%CID_REF
                                                   %TKY = key-%TKY
                                                   %ACTION-Invalidate = if_abap_behv=>mk-on
                                                   %ELEMENT-ConfigDeprecationCode = if_abap_behv=>mk-on
                                                   %msg = mbc_cp_api=>message( )->get_item_invalidated( )
                                                   %PATH-ErrorCode010All-%IS_DRAFT = key-%IS_DRAFT
                                                   %PATH-ErrorCode010All-SingletonID = 1
          ) ).
  ENDMETHOD.
  METHOD COPYERRORCODE010.
    DATA new_ErrorCode010 TYPE TABLE FOR CREATE ZI_ErrorCode010_S\_ErrorCode010.
    DATA new_ErrorCode010Text TYPE TABLE FOR CREATE ZI_ErrorCode010_S\\ErrorCode010\_ErrorCode010Text.

    IF lines( keys ) > 1.
      INSERT mbc_cp_api=>message( )->get_select_only_one_entry( ) INTO TABLE reported-%other.
      failed-ErrorCode010 = VALUE #( FOR fkey IN keys ( %TKY = fkey-%TKY ) ).
      RETURN.
    ENDIF.

    READ ENTITIES OF ZI_ErrorCode010_S IN LOCAL MODE
      ENTITY ErrorCode010
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(ref_ErrorCode010)
        FAILED DATA(read_failed).
    READ ENTITIES OF ZI_ErrorCode010_S IN LOCAL MODE
      ENTITY ErrorCode010 BY \_ErrorCode010Text
        ALL FIELDS WITH CORRESPONDING #( ref_ErrorCode010 )
        RESULT DATA(ref_ErrorCode010Text).

    IF ref_ErrorCode010 IS NOT INITIAL.
      ASSIGN ref_ErrorCode010[ 1 ] TO FIELD-SYMBOL(<ref_ErrorCode010>).
      DATA(key) = keys[ KEY draft %TKY = <ref_ErrorCode010>-%TKY ].
      DATA(key_cid) = key-%CID.
      APPEND VALUE #(
        %TKY-SingletonID = 1
        %IS_DRAFT = <ref_ErrorCode010>-%IS_DRAFT
        %TARGET = VALUE #( (
          %CID = key_cid
          %IS_DRAFT = <ref_ErrorCode010>-%IS_DRAFT
          %DATA = CORRESPONDING #( <ref_ErrorCode010> EXCEPT
          SingletonID
          ConfigDeprecationCode
          LastChangedAt
          LocalLastChangedAt
        ) ) )
      ) TO new_ErrorCode010 ASSIGNING FIELD-SYMBOL(<new_ErrorCode010>).
      <new_ErrorCode010>-%TARGET[ 1 ]-ErrorCode = key-%PARAM-ErrorCode.
      FIELD-SYMBOLS <new_ErrorCode010Text> LIKE LINE OF new_ErrorCode010Text.
      UNASSIGN <new_ErrorCode010Text>.
      LOOP AT ref_ErrorCode010Text ASSIGNING FIELD-SYMBOL(<ref_ErrorCode010Text>).
        DATA(cid_ref_ErrorCode010Text) = key_cid.
        IF <new_ErrorCode010Text> IS NOT ASSIGNED.
          INSERT VALUE #( %CID_REF  = cid_ref_ErrorCode010Text
                          %IS_DRAFT = key-%IS_DRAFT ) INTO TABLE new_ErrorCode010Text ASSIGNING <new_ErrorCode010Text>.
        ENDIF.
        INSERT VALUE #( %IS_DRAFT = key-%IS_DRAFT
                        %DATA = CORRESPONDING #( <ref_ErrorCode010Text> EXCEPT
                                                 SingletonID
                                                 LocalLastChangedAt
        ) ) INTO TABLE <new_ErrorCode010Text>-%target ASSIGNING FIELD-SYMBOL(<target_ErrorCode010Text>).
        <target_ErrorCode010Text>-%KEY-ErrorCode = key-%PARAM-ErrorCode.
        <target_ErrorCode010Text>-%cid = 'ErrorCode010Text'
          && |#{ <ref_ErrorCode010Text>-%KEY-Langu }|
          && |#{ <ref_ErrorCode010Text>-%KEY-ErrorCode }|.
      ENDLOOP.

      MODIFY ENTITIES OF ZI_ErrorCode010_S IN LOCAL MODE
        ENTITY ErrorCode010All CREATE BY \_ErrorCode010
        FIELDS (
                 ErrorCode
               ) WITH new_ErrorCode010
        ENTITY ErrorCode010 CREATE BY \_ErrorCode010Text
        FIELDS (
                 Langu
                 ErrorCode
                 Description
               ) WITH new_ErrorCode010Text
        MAPPED DATA(mapped_create)
        FAILED failed
        REPORTED reported.

      mapped-ErrorCode010 = mapped_create-ErrorCode010.
    ENDIF.

    INSERT LINES OF read_failed-ErrorCode010 INTO TABLE failed-ErrorCode010.

    IF failed-ErrorCode010 IS INITIAL.
      reported-ErrorCode010 = VALUE #( FOR created IN mapped-ErrorCode010 (
                                                 %CID = created-%CID
                                                 %ACTION-CopyErrorCode010 = if_abap_behv=>mk-on
                                                 %MSG = mbc_cp_api=>message( )->get_item_copied( )
                                                 %PATH-ErrorCode010All-%IS_DRAFT = created-%IS_DRAFT
                                                 %PATH-ErrorCode010All-SingletonID = 1 ) ).
    ENDIF.
  ENDMETHOD.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD 'ZI_ERRORCODE010' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%ACTION-Deprecate = is_authorized.
    result-%ACTION-Invalidate = is_authorized.
    result-%ACTION-CopyErrorCode010 = is_authorized.
  ENDMETHOD.
  METHOD GET_INSTANCE_FEATURES.
    READ ENTITIES OF ZI_ErrorCode010_S IN LOCAL MODE
      ENTITY ErrorCode010
      FIELDS ( ConfigDeprecationCode ) WITH CORRESPONDING #( keys )
      RESULT DATA(ErrorCode010).
    DATA keys_act LIKE keys.
    LOOP AT keys INTO DATA(key) USING KEY draft WHERE %is_draft = if_abap_behv=>mk-on.
      key-%is_draft = if_abap_behv=>mk-off.
      INSERT key INTO TABLE keys_act.
    ENDLOOP.
    READ ENTITIES OF ZI_ErrorCode010_S IN LOCAL MODE
      ENTITY ErrorCode010
      FIELDS ( ConfigDeprecationCode ) WITH CORRESPONDING #( keys_act )
      RESULT DATA(ErrorCode010_act).
    LOOP AT keys INTO key.
      DATA(delete) = if_abap_behv=>fc-o-disabled.
      DATA(deprecate) = if_abap_behv=>fc-o-disabled.
      DATA(invalidate) = if_abap_behv=>fc-o-disabled.
      DATA(copy) = if_abap_behv=>fc-o-disabled.
      IF key-%IS_DRAFT = if_abap_behv=>mk-on.
        copy = if_abap_behv=>fc-o-enabled.
        READ TABLE ErrorCode010 WITH KEY draft COMPONENTS %TKY = key-%TKY ASSIGNING FIELD-SYMBOL(<ErrorCode010>).
        IF <ErrorCode010>-ConfigDeprecationCode = ''.
          deprecate = if_abap_behv=>fc-o-enabled.
          invalidate = if_abap_behv=>fc-o-enabled.
        ELSEIF <ErrorCode010>-ConfigDeprecationCode = 'W'.
          invalidate = if_abap_behv=>fc-o-enabled.
        ENDIF.
        IF NOT line_exists( ErrorCode010_act[ KEY entity COMPONENTS %KEY = key-%KEY ] ).
          delete = if_abap_behv=>fc-o-enabled.
        ENDIF.
      ENDIF.
      INSERT VALUE #( %TKY = key-%TKY
                      %DELETE = delete
                      %ACTION-CopyErrorCode010 = copy
                      %ACTION-deprecate = deprecate
                      %ACTION-invalidate = invalidate ) INTO TABLE result.
    ENDLOOP.
  ENDMETHOD.
  METHOD VALIDATETRANSPORTREQUEST.
    DATA change TYPE REQUEST FOR CHANGE ZI_ErrorCode010_S.
    IF keys_ErrorCode010 IS NOT INITIAL.
      DATA(is_draft) = keys_ErrorCode010[ 1 ]-%IS_DRAFT.
    ELSEIF keys_ErrorCode010Text IS NOT INITIAL.
      is_draft = keys_ErrorCode010Text[ 1 ]-%IS_DRAFT.
    ELSE.
      RETURN.
    ENDIF.
    READ ENTITY IN LOCAL MODE ZI_ErrorCode010_S
    FROM VALUE #( ( %IS_DRAFT = is_draft
                    SingletonID = 1
                    %CONTROL-TransportRequestID = if_abap_behv=>mk-on ) )
    RESULT FINAL(transport_from_singleton).
    IF lines( transport_from_singleton ) = 1.
      DATA(transport_request) = transport_from_singleton[ 1 ]-TransportRequestID.
    ENDIF.
    lhc_rap_tdat_cts=>get( )->validate_all_changes(
                                transport_request     = transport_request
                                table_validation_keys = VALUE #(
                                                          ( table = 'ZERRCODE_010' keys = REF #( keys_ErrorCode010 ) )
                                                          ( table = 'ZERRCODET_010' keys = REF #( keys_ErrorCode010Text ) )
                                                               )
                                reported              = REF #( reported )
                                failed                = REF #( failed )
                                change                = REF #( change ) ).
  ENDMETHOD.
ENDCLASS.
