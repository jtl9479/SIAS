/**
 * @license Copyright (c) 2003-2018, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see https://ckeditor.com/legal/ckeditor-oss-license
 */

CKEDITOR.editorConfig = function( config ) {
	// Define changes to default configuration here. For example:
	
	config.language = 'ko'; // 언어설정 툴바 메뉴가 한글로 출력됨(대소문자 구별)
	config.font_names = '맑은 고딕; 돋움; 바탕; 돋음; 궁서; Quattrocento Sans;' + CKEDITOR.config.font_names; //기본 글꼴에 +기호로 한글 글꼴을 추가 한다.	
	config.filebrowserImageUploadUrl = '/ckeditor/imgUpload.do';
	
	config.toolbar =
		[
		[ /*'NewPage','Preview'*/ ],
		[ /*'Cut','Copy','Paste','PasteText','PasteFromWord','-','Undo','Redo'*/ ],
		['Font', 'FontSize'],
        ['BGColor', 'TextColor' ], 
		[ 'Find','Replace','-','SelectAll'/*,'-'*/,'Scayt' ],
		/*[ 'Image','Flash','Table','HorizontalRule','SpecialChar','PageBreak'],*/
		/*[ 'Image','Table','HorizontalRule','SpecialChar','PageBreak'], 2019-01-15 Table제거 적용전 - 영완*/
		[ 'Image','HorizontalRule','SpecialChar','PageBreak'],
		'/',
		[ 'Styles','Format' ],
		['Bold', 'Italic', 'Strike', 'Superscript', 'Subscript', 'Underline', 'RemoveFormat'],   
		];	
};
