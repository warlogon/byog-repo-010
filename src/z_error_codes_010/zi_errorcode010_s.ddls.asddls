@EndUserText.label: 'Error Code 010 Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZI_ErrorCode010_S
  as select from I_Language
    left outer join ZERRCODE_010 on 0 = 0
  composition [0..*] of ZI_ErrorCode010 as _ErrorCode010
{
  key 1 as SingletonID,
  _ErrorCode010,
  max( ZERRCODE_010.LAST_CHANGED_AT ) as LastChangedAtMax,
  cast( '' as SXCO_TRANSPORT) as TransportRequestID,
  cast( 'X' as ABAP_BOOLEAN preserving type) as HideTransport
  
}
where I_Language.Language = $session.system_language
