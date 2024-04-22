@EndUserText.label: 'Maintain Error Code 010 Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'SingletonID' ]
define root view entity ZC_ErrorCode010_S
  provider contract transactional_query
  as projection on ZI_ErrorCode010_S
{
  key SingletonID,
  LastChangedAtMax,
  TransportRequestID,
  HideTransport,
  _ErrorCode010 : redirected to composition child ZC_ErrorCode010
  
}
