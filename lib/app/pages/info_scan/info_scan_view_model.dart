part of 'info_scan_page.dart';

class InfoScanViewModel extends PageViewModel<InfoScanState, InfoScanStateStatus> {

  InfoScanViewModel({ required ApiInfoScan infoScan }) : super(InfoScanState(infoScan: infoScan));

  @override
  InfoScanStateStatus get status => state.status;
}
