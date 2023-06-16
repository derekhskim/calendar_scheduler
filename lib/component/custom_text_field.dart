import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../const/colors.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final bool isTime;
  final FormFieldSetter<String> onSaved;
  final String initialValue;

  /// true - 시간 / false - 내용

  const CustomTextField({
    required this.label,
    required this.isTime,
    required this.onSaved,
    required this.initialValue,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: PRIMARY_COLOR,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (isTime) renderTextField(),
        if (!isTime)
          Expanded(
            child: renderTextField(),
          ),
      ],
    );
  }

  Widget renderTextField() {
    return TextFormField(
      onSaved: onSaved,
      // FORM
      // null이 리턴되면 에러가 없다.
      // 에러가 있으면 에러를 String 값으로 리턴해준다.
      validator: (String? val){
        if(val == null || val.isEmpty) {
          return 'Please enter val';
        }

        if(isTime){
          int time = int.parse(val);

          if(time < 0) {
            return '0 이상의 숫자를 입력해주세요';
          }

          if(time > 24) {
            return '24 이하의 숫자를 입력해주세요';
          }

        } else {

        }

        return null;
      },
      cursorColor: Colors.grey,
      maxLines: isTime ? 1 : null,
      expands: !isTime,
      initialValue: initialValue,
      keyboardType: isTime ? TextInputType.number : TextInputType.multiline,
      inputFormatters: isTime
          ? [
              FilteringTextInputFormatter.digitsOnly,
            ]
          : [],
      decoration: InputDecoration(
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.grey[300],
        suffixText: isTime ? 'hr' : null,
      ),
    );
  }
}
