(function() {
    var positionFooter,applicationsTable, jobsTable, paymentsTable, proceduresTable, setupTables,attachedFilesTable, templatesTable, userapplicationsTable, usersTable, uploadsTable;

    positionFooter = function(){
        var obj = $("#footer");
        if ($("body").outerHeight(true) > $(window).height()) {
            obj.css("position","relative");
            obj.css("marginBottom", 0);
        } else {
            obj.css("position","fixed");
            obj.css("bottom","0px");
        }
    }

jobsTable = function(el) {
    $(el).dataTable({
        sPaginationType: "bootstrap",
        sDom: "<'row'<'col-sm-12'f>r>t<'row'<'col-sm-12'p>r>",
        bProcessing: true,
        retrieve: true,
        bServerSide: true,
        bFilter: true,
        bInfo: false,
        bSort: false,
        iDisplayLength: 5,
        sAjaxSource: "joblist",
        aoColumns: [
            {
              mData: "title"
            }, {
              mData: "applicants"
            }, {
              mData: "deadline"
            }, {
              mData: "status"
            }, {
              mData: "options1"
            }, {
              mData: "options2"
            }
        ],
        aoColumnDefs: [
        {
            aTargets: [4],
            fnRender: function(o) {
                return o.aData.options1;
            }
        }, {
            aTargets: [5],
            fnRender: function(o) {
            return o.aData.options2;
            }
        }
        ],
        fnServerParams: function(aoData) {
            var filter;
            filter = void 0;
            filter = $(el).data("filter");
            aoData.push({
              name: "filter",
              value: filter
            });
        },
        fnDrawCallback: function(settings) {
            positionFooter();
        }
    });
};

usersTable = function(el) {
$(el).dataTable({
    sPaginationType: "bootstrap",
    sDom: "<'row'<'col-sm-12'f>r>t<'row'<'col-sm-12'p>r>",
    bProcessing: true,
    retrieve: true,
    bServerSide: true,
    bFilter: true,
    bInfo: false,
    bSort: false,
    iDisplayLength: 5,
    sAjaxSource: "userlist",
    aoColumns: [
      {
        mData: "first_name"
      }, {
        mData: "last_name"
      }, {
        mData: "email"
      }, {
        mData: "status"
      }, {
        mData: "action"
      }
    ],
    fnServerParams: function(aoData) {
      var role;
      role = void 0;
      role = $(el).data("role");
      aoData.push({
        name: "role",
        value: role
      });
    }
});
};

templatesTable = function(el) {
$(el).dataTable({
    sPaginationType: "bootstrap",
    sDom: "<'row'<'col-sm-12'>r>t<'row'<'col-sm-12'p>r>",
    bProcessing: true,
    retrieve: true,
    bServerSide: true,
    bFilter: true,
    bInfo: false,
    bSort: false,
    iDisplayLength: 5,
    sAjaxSource: "templatelist",
    aoColumns: [
      {
        mData: "title"
      }, {
        mData: "questions"
      }, {
        mData: "options"
      }
    ],
    fnServerParams: function(aoData) {
      var addto, job;
  addto = void 0;
  addto = $(el).data("add_to");
  job = void 0;
  job = $(el).data("job_token");
  aoData.push({
    name: "job_token",
    value: job
  });
  aoData.push({
    name: "add_to",
    value: addto
  });
}
});
};

applicationsTable = function(el) {
$(el).dataTable({
  sPaginationType: "bootstrap",
  sDom: "t<'row'<'col-sm-12'p>r>",
  bProcessing: true,
  retrieve: true,
  bServerSide: true,
  bFilter: true,
  bInfo: false,
  bSort: false,
  iDisplayLength: 5,
  sAjaxSource: "applicationlist",
  aoColumns: [
    {
      mData: "name"
    }, {
      mData: "rating"
    }, {
      mData: "status"
    }, {
      mData: "stage"
    }, {
      mData: "options1"
    }, {
      mData: "options2"
    }
  ],
  aoColumnDefs: [
    {
      aTargets: [1],
      mRender: function(data, type, oObj) {
return "<p id='" + oObj.id + "'></p>";
}
}
],
fnServerParams: function(aoData) {
  var filter, job, onlyactive, stage;
onlyactive = void 0;
onlyactive = $(el).data("show_only_active");
filter = void 0;
filter = $(el).data("filter_id");
stage = void 0;
stage = $(el).data("stage_id");
job = void 0;
job = $(el).data("job_id");
aoData.push({
  name: "job_id",
  value: job
});
aoData.push({
  name: "filter_id",
  value: filter
});
aoData.push({
  name: "stage_id",
  value: stage
});
aoData.push({
  name: "only_active",
  value: onlyactive
});
},
createdRow: function(row, data, index) {
  var row_el;
row_el = $(row).find("p#" + data.id);
row_el.raty({
  readOnly: true,
  score: data.rating,
  path: '/assets',
  starOn: '../' + image_path('star-on.png'),
  starOff: '../' + image_path('star-off.png'),
  starHalf: '../' + image_path('star-half.png')
});
}
});
};

proceduresTable = function(el) {
$(el).dataTable({
    sPaginationType: "bootstrap",
    sDom: "<'row'<'col-sm-12'>r>t<'row'<'col-sm-12'p>r>",
    bProcessing: true,
    retrieve: true,
    bServerSide: true,
    bFilter: true,
    bInfo: false,
    bSort: false,
    iDisplayLength: 5,
    sAjaxSource: "procedurelist",
    aoColumns: [
      {
        mData: "title"
      }, {
        mData: "stages"
      }, {
        mData: "options"
      }
    ],
    fnServerParams: function(aoData) {
      var addto, job;
  addto = void 0;
  addto = $(el).data("add_to");
  job = void 0;
  job = $(el).data("job_token");
  aoData.push({
    name: "job_token",
    value: job
  });
  aoData.push({
    name: "add_to",
    value: addto
  });
}
});
};

    uploadsTable = function(el){
        $(el).dataTable({
            sPaginationType: "bootstrap",
            sDom: "<'row'<'col-sm-12'>r>t<'row'<'col-sm-12'p>r>",
            bProcessing: true,
            retrieve: true,
            bServerSide: true,
            bFilter: true,
            bInfo: false,
            bSort: false,
            iDisplayLength: 5,
            sAjaxSource: "uploads",
            aoColumns: [
                {
                    mData: "upload_type"
                }, {
                    mData: "description"
                }, {
                    mData: "date"
                }, {
                    mData: "actions"
                }
            ],
            fnServerParams: function(aoData) {
                var role = $(el).data("role");
                aoData.push({
                    name: "role",
                    value: role
                });
                var returnto = $(el).data("returnto");
                aoData.push({
                    name: "return_to",
                    value: returnto
                });
                if(role == "attachment"){
                    var application = $(el).data("application");
                    aoData.push({
                        name: "application_id",
                        value: application
                    });
                }
            }
        });
    };

    attachedFilesTable = function(el){
        $(el).dataTable({
            sPaginationType: "bootstrap",
            sDom: "<'row'<'col-sm-12'>r>t<'row'<'col-sm-12'p>r>",
            bProcessing: true,
            retrieve: true,
            bServerSide: true,
            bFilter: true,
            bInfo: false,
            bSort: false,
            iDisplayLength: 5,
            sAjaxSource: "attached",
            aoColumns: [
                {
                    mData: "upload_type"
                }, {
                    mData: "description"
                }, {
                    mData: "actions"
                }
            ],
            fnServerParams: function(aoData) {
                var application = $(el).data("application");
                aoData.push({
                    name: "application_id",
                    value: application
                });
                var returnto = $(el).data("returnto");
                aoData.push({
                    name: "return_to",
                    value: returnto
                });
            }
        });
    };

userapplicationsTable = function(el) {
$(el).dataTable({
  sPaginationType: "bootstrap",
  sDom: "<'row'<'col-sm-12'f>r>t<'row'<'col-sm-12'p>r>",
  bProcessing: true,
  retrieve: true,
  bServerSide: true,
  bFilter: true,
  bInfo: false,
  bSort: false,
  iDisplayLength: 5,
  sAjaxSource: "userapplications",
  aoColumns: [
    {
      mData: "company"
    }, {
      mData: "position"
    }, {
      mData: "deadline"
    }, {
      mData: "status"
    }, {
      mData: "options"
    }
  ]
});
};

paymentsTable = function(el) {
$(el).dataTable({
  sPaginationType: "bootstrap",
  sDom: "<'row'<'col-sm-12'f>r>t<'row'<'col-sm-12'p>r>",
  bProcessing: true,
  retrieve: true,
  bServerSide: true,
  bFilter: false,
  bInfo: false,
  bSort: false,
  iDisplayLength: 5,
  sAjaxSource: "payments",
  aoColumns: [
    {
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

    setupTables = function() {
        var tables;
        tables = void 0;
        tables = $("body").find("table[id^='datatable-payments_']");
        tables.each(function(index) {
            paymentsTable(this);
        });
        tables = void 0;
        tables = $("body").find("table[id^='datatable-jobs_']");
        tables.each(function(index) {
            jobsTable(this);
        });
        tables = void 0;
        tables = $("body").find("table[id^='datatable-users_']");
        tables.each(function(index) {
            usersTable(this);
        });
        tables = void 0;
        tables = $("body").find("table[id^='datatable-templates_']");
        tables.each(function(index) {
            templatesTable(this);
        });
        tables = void 0;
        tables = $("body").find("table[id^='datatable-applications_']");
        tables.each(function(index) {
            applicationsTable(this);
        });
        tables = void 0;
        tables = $("body").find("table[id^='datatable-procedures_']");
        tables.each(function(index) {
            proceduresTable(this);
        });
        tables = void 0;
        tables = $("body").find("table[id^='datatable-user-applications_']");
        tables.each(function(index) {
            userapplicationsTable(this);
        });

        var table = $('#uploads');
        if(table != null){
            uploadsTable(table);
        }
        var table = $('#attached');
        if(table != null){
            attachedFilesTable(table);
        }
    };

    $(document).ready(function() {
        return setupTables();
    });

}).call(this);
