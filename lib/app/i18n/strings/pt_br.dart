import './strings.dart';

class PtBr implements Translations {
  String get alreadyExists => 'Este pacote já está sendo rastreado';
  String get badRequest => 'Algo deu errado, tente novamente mais tarde';
  String get forbidden => 'Algo deu errado, tente novamente mais tarde';
  String get notFound => "Este não é um código Correios válido ";
  String get cancel => 'Cancelar';
  String get newTrackingPackage => 'Novo rastreio de pacote';
  String get notCompletedPackages => 'Você não tem rastreios ativos';
  String get tranckindCode => 'Código de rastreio';
  String get packageName => 'Nome do pacote';
  String get getTracking => 'Rastrear';
  String get inTransit => 'Em trânsito';
  String get completed => 'Concluídas';
  String get completedPackages => 'Você não tem rastreios completos';
  String get nearbyAgencies => 'Agências Próximas';
  String get unauthorized =>
      'Serviço indisponível, por favor tente novamente mais tarde';
  String get setup => 'Configurações';
  String get invalidName => 'Nome inválido';
  String get unexpected => 'Algo errado aconteceu, tente novamente mais tarde';
  String get invalidCode => 'Código de rastreio inválido';
  String get noResponse =>
      'O serviço não retornou eventos para este código de rastreio.';
  String get serverError =>
      'Erro de servidor interno, tente novamente mais tarde';
}
