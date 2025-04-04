import 'package:flutter/material.dart';
import 'package:my_archive_idea/data/idea_info.dart';
import 'package:my_archive_idea/database/database_helper.dart';

class EditScreen extends StatefulWidget {
  IdeaInfo? ideaInfo;

  EditScreen({super.key, this.ideaInfo});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  // 아이디어 제목
  final TextEditingController _titleEditingController = TextEditingController();

  // 아이디어 계기
  final TextEditingController _motiveEditingController =
      TextEditingController();

  // 아이디어 내용
  final TextEditingController _contentEditingController =
      TextEditingController();

  // 피드백 사항
  final TextEditingController _feedbackEditingController =
      TextEditingController();

  // 아이디어 중요도 점수 container 클릭 상태 관리 변수
  bool isClickPoint1 = false;
  bool isClickPoint2 = false;
  bool isClickPoint3 = true;
  bool isClickPoint4 = false;
  bool isClickPoint5 = false;

  // 아이디어 선택된 현재 중요도 점수 (default value = 3)
  int priorityPoint = 3;

  // database helper
  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();

    // 기존 데이터를 수정할 경우 수정의 편의를 위해서 기존의 데이터를 입력 위젯에 자동 기입
    if (widget.ideaInfo != null) {
      // 입력 필드들 세팅
      _titleEditingController.text = widget.ideaInfo!.title;
      _motiveEditingController.text = widget.ideaInfo!.motive;
      _contentEditingController.text = widget.ideaInfo!.content;
      // 피드백 입력필드의 경우는 선택 사항 입력 필드라서 따로 값이 비었는지 체크 필요 !
      if (widget.ideaInfo!.feedback.isNotEmpty) {
        _feedbackEditingController.text = widget.ideaInfo!.feedback;
      }

      // 아이디어 중요도 점수 세팅
      initClickStatus();
      switch (widget.ideaInfo!.priority) {
        case 1:
          isClickPoint1 = true;
          break;

        case 2:
          isClickPoint2 = true;
          break;

        case 3:
          isClickPoint3 = true;
          break;

        case 4:
          isClickPoint4 = true;
          break;

        case 5:
          isClickPoint5 = true;
          break;
      }
      priorityPoint = widget.ideaInfo!.priority;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          child: Icon(Icons.arrow_back_ios_new, size: 24, color: Colors.black),
          onTap: () {
            // back button
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.ideaInfo == null ? '새 아이디어 작성하기' : '아이디어 편집',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('제목'),
              Container(
                margin: EdgeInsets.only(top: 8),
                height: 41,
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 16,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffd9d9d9)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: '아이디어 제목',
                    hintStyle: TextStyle(color: Color(0xffb4b4b4)),
                  ),
                  style: TextStyle(fontSize: 12, color: Colors.black),
                  controller: _titleEditingController,
                ),
              ),

              SizedBox(height: 16),
              Text('아이디어를 떠올린 계기'),
              Container(
                margin: EdgeInsets.only(top: 8),
                height: 41,
                child: TextField(
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 16,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffd9d9d9)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: '아이디어를 떠올린 계기',
                    hintStyle: TextStyle(color: Color(0xffb4b4b4)),
                  ),
                  style: TextStyle(fontSize: 12, color: Colors.black),
                  controller: _motiveEditingController,
                ),
              ),

              SizedBox(height: 16),
              Text('아이디어 내용'),
              Container(
                margin: EdgeInsets.only(top: 8),
                child: TextField(
                  maxLength: 500,
                  maxLines: 5,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffd9d9d9)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: '아이디어 내용',
                    hintStyle: TextStyle(color: Color(0xffb4b4b4)),
                  ),
                  style: TextStyle(fontSize: 12, color: Colors.black),
                  controller: _contentEditingController,
                ),
              ),

              SizedBox(height: 16),
              Text('아이디어 중요도 점수'),
              Container(
                margin: EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        width: 50,
                        height: 40,
                        decoration: ShapeDecoration(
                          color:
                              isClickPoint1 ? Color(0xffd6d6d6) : Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          '1',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onTap: () {
                        // 1. 모든 버튼 값 초기화
                        initClickStatus();
                        // 2. 선택된 버튼에 대한 변수 값 및 위젯 update
                        setState(() {
                          priorityPoint = 1;
                          isClickPoint1 = true;
                        });
                      },
                    ),
                    GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        width: 50,
                        height: 40,
                        decoration: ShapeDecoration(
                          color:
                              isClickPoint2 ? Color(0xffd6d6d6) : Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          '2',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onTap: () {
                        // 1. 모든 버튼 값 초기화
                        initClickStatus();
                        // 2. 선택된 버튼에 대한 변수 값 및 위젯 update
                        setState(() {
                          priorityPoint = 2;
                          isClickPoint2 = true;
                        });
                      },
                    ),
                    GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        width: 50,
                        height: 40,
                        decoration: ShapeDecoration(
                          color:
                              isClickPoint3 ? Color(0xffd6d6d6) : Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          '3',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onTap: () {
                        // 1. 모든 버튼 값 초기화
                        initClickStatus();
                        // 2. 선택된 버튼에 대한 변수 값 및 위젯 update
                        setState(() {
                          priorityPoint = 3;
                          isClickPoint3 = true;
                        });
                      },
                    ),
                    GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        width: 50,
                        height: 40,
                        decoration: ShapeDecoration(
                          color:
                              isClickPoint4 ? Color(0xffd6d6d6) : Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          '4',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onTap: () {
                        // 1. 모든 버튼 값 초기화
                        initClickStatus();
                        // 2. 선택된 버튼에 대한 변수 값 및 위젯 update
                        setState(() {
                          priorityPoint = 4;
                          isClickPoint4 = true;
                        });
                      },
                    ),
                    GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        width: 50,
                        height: 40,
                        decoration: ShapeDecoration(
                          color:
                              isClickPoint5 ? Color(0xffd6d6d6) : Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          '5',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onTap: () {
                        // 1. 모든 버튼 값 초기화
                        initClickStatus();
                        // 2. 선택된 버튼에 대한 변수 값 및 위젯 update
                        setState(() {
                          priorityPoint = 5;
                          isClickPoint5 = true;
                        });
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),
              Text('유저 피드백 사항(선택)'),
              Container(
                margin: EdgeInsets.only(top: 8),
                child: TextField(
                  maxLength: 500,
                  maxLines: 5,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffd9d9d9)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: '떠오르신 아이디어 기반으로\n전달받은 피드백들을 정리해주세요',
                    hintStyle: TextStyle(color: Color(0xffb4b4b4)),
                  ),
                  style: TextStyle(fontSize: 12, color: Colors.black),
                  controller: _feedbackEditingController,
                ),
              ),

              SizedBox(height: 16),

              /// 아이디어 작성 완료 버튼
              GestureDetector(
                child: Container(
                  height: 65,
                  alignment: Alignment.center,
                  child: Text('아이디어 작성 완료'),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onTap: () async {
                  // 아이디어 작성 (database insert) 처리
                  String titleValue = _titleEditingController.text.toString();
                  String motiveValue = _motiveEditingController.text.toString();
                  String contentValue =
                      _contentEditingController.text.toString();
                  String feedbackValue =
                      _feedbackEditingController.text.toString();

                  // 유효성 검사 (비어 있는 필수 입력 값에 대한 체크)
                  if (titleValue.isEmpty ||
                      motiveValue.isEmpty ||
                      contentValue.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('비어 있는 입력 값이 존재합니다'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    return;
                  }

                  // 새 아이디어를 작성하는 경우 (insert)
                  if (widget.ideaInfo == null) {
                    // 아이디어 정보 클래스 인스턴스 생성 후 db 삽입
                    var ideaInfo = IdeaInfo(
                      title: titleValue,
                      motive: motiveValue,
                      content: contentValue,
                      priority: priorityPoint,
                      feedback: feedbackValue.isNotEmpty ? feedbackValue : '',
                      createdAt: DateTime.now().millisecondsSinceEpoch,
                    );

                    await setInsertIdeaInfo(ideaInfo);
                    if (mounted) {
                      // 모든 시나리오가 완료되었으니 이전화면으로 이동
                      Navigator.pop(context, 'insert');
                    } else {
                      // 기존의 아이디어를 업데이트 하는 경우 (update)
                      var ideaInfoModify = widget.ideaInfo;
                      ideaInfoModify?.title = titleValue;
                      ideaInfoModify?.motive = motiveValue;
                      ideaInfoModify?.content = contentValue;
                      ideaInfoModify?.priority = priorityPoint;
                      ideaInfoModify?.feedback =
                          feedbackValue.isNotEmpty ? feedbackValue : '';

                      // update screen
                      await setInsertIdeaInfo(ideaInfoModify!);

                      // close screen
                      if (mounted) {
                        Navigator.pop(context, 'update');
                      }
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future setInsertIdeaInfo(IdeaInfo ideaInfo) async {
    // 삽입 하는 메서드
    await dbHelper.initDatabase();
    await dbHelper.insertIdeaInfo(ideaInfo);
  }

  void initClickStatus() {
    // 클릭 상태를 초기화 해주는 함수
    isClickPoint1 = false;
    isClickPoint2 = false;
    isClickPoint3 = false;
    isClickPoint4 = false;
    isClickPoint5 = false;
  }
}
