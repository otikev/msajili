(function() {
    var companiesTable;
    companiesTable = function() {
        var table = $('#agent_companies_table');
        if(table == null){
            return;
        }
        table.dataTable({
            sPaginationType: "bootstrap",
            sDom: "<'row'<'col-sm-12'f>r>t<'row'<'col-sm-12'p>r>",
            bProcessing: true,
            retrieve: true,
            bServerSide: true,
            bFilter: true,
            bInfo: false,
            bSort: false,
            iDisplayLength: 10,
            sAjaxSource: "agentcontacts",
            aoColumns: [
                {
                    mData: "name"
                }, {
                    mData: "package"
                }, {
                    mData: "commission"
                }
            ]
        });
    };

    $(document).ready(function() {
        companiesTable();
    });

}).call(this);