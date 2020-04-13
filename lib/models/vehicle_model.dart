class VehicleModel {
  String nvis_color;
  String nvis_cartype;
  String nvis_status;
  String category;
  String immatriculation;
  final String userId;
  String filePath;
  String picture_file_url;
  bool update;
//  String filename;
  VehicleModel(
      {this.nvis_color,
      this.nvis_cartype,
      this.nvis_status,
      this.category,
      this.immatriculation,
      this.userId,
      this.filePath,
      this.picture_file_url,
      this.update});

  setVehicleCategory(String value) {
    this.category = value;
  }

  setVehicleImmatriculation(String value) {
    this.immatriculation = value;
  }

  setVehicleColor(String value) {
    this.nvis_color = value;
  }

  setVehicleCartype(String value) {
    this.nvis_cartype = value;
  }

  setVehicleCarstatus(String value) {
    this.nvis_status = value;
  }

  setVehicleurlfilePath(String value) {
    this.filePath = value;
  }

  setVehiclepicture_file_url(String value) {
    this.picture_file_url = value;
  }

  setupdate(bool value) {
    this.update = value;
  }
}
