import 'package:intl/intl.dart';

extension DateFormatter on String{
  String toFormattedData(){
    if(trim().isEmpty) return 'No Date';

    try{
      final DateTime parsedDate = DateTime.parse(this);
      return DateFormat('dd MMM yyyy, hh:mm a').format(parsedDate);
    }catch(e){
      return this;
    }
  }
}