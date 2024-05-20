const String linkServerName = "http://192.168.0.104/doctorAPI";

//Login
const String Apilogin = "$linkServerName/login";
//---------------------------------------------------------
//Patientsadd
const String Apipatientsadd = "$linkServerName/patientsadd";
//---------------------------------------------------------
//Users
const String Apiusers = "$linkServerName/adduser";
//add user
const String ApiaddUser = "$linkServerName/adduser/insert";
//delete user
const String ApideleteUser = "$linkServerName/adduser/delete";
//update user
const String ApiupdateUser = "$linkServerName/adduser/update";
//---------------------------------------------------------
//Earnings
const String Apiearnings = "$linkServerName/earnings";
//earnings - expenses
const String ApiearningsExpenses = "$linkServerName/earnings/expenses";
//earnings - income
const String ApiearningsIncome = "$linkServerName/earnings/income";
//earnings - getweredate
const String ApiearningsGetweredate = "$linkServerName/earnings/getweredate";
//---------------------------------------------------------
//Patientsdate
const String Apipatientsdate = "$linkServerName/patientsdate";
const String Apipatientsdateindextwo = "$linkServerName/patientsdate/indextwo";
//insert - patientsdate
const String ApiinsertPatientsdate = "$linkServerName/patientsdate/insert";
const String ApiinsertPatientsdatefellow =
    "$linkServerName/patientsdate/inserttwo";
//delete - patientsdate
const String ApideletePatientsdate = "$linkServerName/patientsdate/delete";
//update - patientsdate
const String ApiupdatePatientsdate = "$linkServerName/patientsdate/update";
//search - patientsdate
const String ApisearchPatientsdate = "$linkServerName/patientsdate/search";
const String ApisearchPatientsdatesearchtwo =
    "$linkServerName/patientsdate/searchtwo";
//---------------------------------------------------------
//patientsold
const String Apipatientsold = "$linkServerName/patientsold";
//insert - patientsold
const String ApiinsertPatientsold = "$linkServerName/patientsold/insert";
//delete - patientsold
const String ApideletePatientsold = "$linkServerName/patientsold/delete";
//update - patientsold
const String ApiupdatePatientsold = "$linkServerName/patientsold/update";
//---------------------------------------------------------
//Patientsready
const String Apipatientsready = "$linkServerName/patientsready";
const String alloftodatid = "$linkServerName/doctorAPI/alloftodayid/";
//Patientsready delete
const String Apipatientsreadydelete = "$linkServerName/patientsready/delete";
//insert - patientsready
const String ApiinsertPatientsready = "$linkServerName/patientsready/insert";
//insert - patientsready next time
const String ApiinsertPatientsreadynexttime =
    "$linkServerName/patientsready/insert/nexttime";
//list - patientsready
const String ApilistviewPatientsready =
    "$linkServerName/patientsready/listview";

const String ListviewPatientsMinus = "$linkServerName/alloftoday/";
//---------------------------------------------------------
//Patientssearch
const String Apipatientssearch = "$linkServerName/patientssearch";
//---------------------------------------------------------
//Patientsvisit
const String Apipatientsvisit = "$linkServerName/patientsvisit";
//---------------------------------------------------------
//Patientsvisit
const String Apiinvestigations = "$linkServerName/investigations";
//Patientsvisit path pdf
const String Apiinvestigationspath = "$linkServerName/investigations/pdffile/";
//Patientsvisit insert pdf
const String Apiinsertpdf = "$linkServerName/investigations/upload";
//----------------------------------------------------------
//prent
const String Apiprent = "$linkServerName/print";
// All Of Today NextVisit

const String AllOfTodayNextVisit = '${linkServerName}/pready/';
