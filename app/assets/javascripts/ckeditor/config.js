CKEDITOR.editorConfig = function( config ) {
    config.language = 'zh-CN';
    config.uiColor = '#dde8eb';
    config.toolbarGroups = [
        { name: 'clipboard',   groups: [ 'clipboard', 'undo' ] },
        { name: 'editing',     groups: [ 'find', 'selection', 'spellchecker' ] },
        { name: 'tools' },
        { name: 'document',    groups: [ 'mode' ] },
        { name: 'others' },
        '/',
        { name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ] },
        { name: 'paragraph',   groups: [ 'list', 'indent', 'blocks', 'align' ] },
        { name: 'styles' },
        { name: 'colors' }
    ];
    config.toolbar = 'Groups';
};
