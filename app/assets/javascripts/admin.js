(function() {
    var usersTable;
    var agentRequestsTable;
    var companiesTable;
    var jobsTable;
    var anonymousJobsTable;
    var paymentsTable;
    var staffTable;

    staffTable = function() {
        var table = $('#staff_table');
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
            sAjaxSource: "stafflist",
            aoColumns: [
                {
                    mData: "email"
                }, {
                    mData: "name"
                }, {
                    mData: "role"
                }, {
                    mData: "status"
                }, {
                    mData: "options"
                }
            ]
        });
    };

    usersTable = function() {
        var table = $('#admin_users_table');
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
            sAjaxSource: "adminuserlist",
            aoColumns: [
                {
                    mData: "first_name"
                }, {
                    mData: "last_name"
                }, {
                    mData: "email"
                }, {
                    mData: "company"
                }, {
                    mData: "status"
                }, {
                    mData: "role"
                }
            ]
        });
    };

    agentRequestsTable = function() {
        var table = $('#admin_agent_requests_table');
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
            sAjaxSource: "adminagentrequestlist",
            aoColumns: [
                {
                    mData: "first_name"
                }, {
                    mData: "last_name"
                }, {
                    mData: "email"
                }, {
                    mData: "phone"
                }, {
                    mData: "created_at"
                },{
                    mData: "action"
                }
            ]
        });
    };

    companiesTable = function() {
        var table = $('#admin_companies_table');
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
            sAjaxSource: "admincompanylist",
            aoColumns: [
                {
                    mData: "name"
                }, {
                    mData: "phone"
                }, {
                    mData: "country"
                }, {
                    mData: "website"
                }, {
                    mData: "package"
                }, {
                    mData: "token"
                }, {
                    mData: "action"
                }
            ]
        });
    };

    anonymousJobsTable = function() {
        var table = $('#anonymous_jobs_table');
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
            sAjaxSource: "adminjoblist",
            columnDefs: [
                { "width": "30%", "targets": 0 },
                { "width": "20%", "targets": 1 },
                { "width": "20%", "targets": 5 }
            ],
            aoColumns: [
                {
                    mData: "title"
                }, {
                    mData: "company"
                }, {
                    mData: "views"
                }, {
                    mData: "status"
                }, {
                    mData: "deadline"
                }, {
                    mData: "options"
                }
            ],
            fnServerParams: function(aoData) {
                aoData.push({
                    name: "job_type",
                    value: 1
                });
            }
        });
    };

    jobsTable = function() {
        var table = $('#admin_jobs_table');
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
            sAjaxSource: "adminjoblist",
            aoColumns: [
                {
                    mData: "title"
                }, {
                    mData: "company"
                }, {
                    mData: "applicants"
                }, {
                    mData: "status"
                }, {
                    mData: "deadline"
                }, {
                    mData: "options"
                }
            ],
            fnServerParams: function(aoData) {
                aoData.push({
                    name: "job_type",
                    value: 0
                });
            }
        });
    };

    paymentsTable = function() {
        var table = $('#admin_payments_table');
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
            sAjaxSource: "adminpaymentlist",
            aoColumns: [
                {
                    mData: "company"
                }, {
                    mData: "reference"
                }, {
                    mData: "package"
                }, {
                    mData: "description"
                }, {
                    mData: "quantity"
                }, {
                    mData: "status"
                }, {
                    mData: "created_at"
                }
            ]
        });
    };

    $(document).ready(function() {
        usersTable();
        agentRequestsTable();
        companiesTable();
        jobsTable();
        paymentsTable();
        anonymousJobsTable();
        staffTable();
    });

}).call(this);