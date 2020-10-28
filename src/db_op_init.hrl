{tables,
 [{computer,[{attributes,[host_id,
			  ssh_uid,
			  ssh_passwd,
			  ip_addr,
			  port,
			  status]},
	     {disc_copies,['op@asus']}]},
  
  {vm,[{attributes,[vm,
		    host_id,
		    vm_id,
		    type,
		    status]},
       {disc_copies,['op@asus']}]},

  {service_def,[{attributes,[service_id,
			     vsn,
			     git_user_id]},
		{disc_copies,['op@asus']},
		{type,bag}]},
  
  {deployment_spec,[{attributes,[deployment_spec_id,
				 vsn,
				 restrictions,
				 services]},
		    {ram_copies,['op@asus']},
		    {type,bag}]},
  
  {deployment,[{attributes,[deployment_id,
			    deployment_spec_id,
			    deployment_spec_vsn,
			    date,
			    time,
			    sd_list]},
	       {ram_copies,['op@asus']}]},
  
  {sd,[{attributes,[service_id,
		    vsn,
		    host_id,
		    vm_id,
		    vm]},
       {ram_copies,['op@asus']}]},
  
  {passwd,[{attributes,[user_id,
			passwd]},
	   {disc_copies,['op@asus']},
	   {type,bag}]}
 ]
}.

{computer,"asus","pi","festum01","192.168.0.100",60100,not_available}.
{computer,"sthlm_1","pi","festum01","192.168.0.110",60110,not_available}.
{computer,"wrong_hostname","pi","festum01","192.168.0.110",60100,not_available}.
{computer,"wrong_ipaddr","pi","festum01","25.168.0.110",60100,not_available}.
{computer,"wrong_port","pi","festum01","192.168.0.110",2323,not_available}.
{computer,"wrong_userid","glurk","festum01","192.168.0.110",60100,not_available}.
{computer,"wrong_passwd","pi","glurk","192.168.0.110",60100,not_available}.

{vm,'10250@asus',"asus","10250",controller,not_available}.
{vm,'30000@asus',"asus","30000",worker,not_available}.
{vm,'30001@asus',"asus","30001",worker,not_available}.
{vm,'30002@asus',"asus","30003",worker,not_available}.
{vm,'30003@asus',"asus","30003",worker,not_available}.
{vm,'30004@asus',"asus","30004",worker,not_available}.
{vm,'30005@asus',"asus","30005",worker,not_available}.
{vm,'30006@asus',"asus","30006",worker,not_available}.
{vm,'30007@asus',"asus","30007",worker,not_available}.
{vm,'30008@asus',"asus","30008",worker,not_available}.
{vm,'30009@asus',"asus","30009",worker,not_available}.

{vm,'10250@sthlm_1',"sthlm_1","10250",controller,not_available}.
{vm,'30000@sthlm_1',"sthlm_1","30000",worker,not_available}.
{vm,'30001@sthlm_1',"sthlm_1","30001",worker,not_available}.
{vm,'30002@sthlm_1',"sthlm_1","30003",worker,not_available}.
{vm,'30003@sthlm_1',"sthlm_1","30003",worker,not_available}.
{vm,'30004@sthlm_1',"sthlm_1","30004",worker,not_available}.
{vm,'30005@sthlm_1',"sthlm_1","30005",worker,not_available}.
{vm,'30006@sthlm_1',"sthlm_1","30006",worker,not_available}.
{vm,'30007@sthlm_1',"sthlm_1","30007",worker,not_available}.
{vm,'30008@sthlm_1',"sthlm_1","30008",worker,not_available}.
{vm,'30009@sthlm_1',"sthlm_1","30009",worker,not_available}.

{service_def,"adder_service","1.0.0","joq62"}.
{service_def,"multi_service","1.0.0","joq62"}.
{service_def,"divi_service","1.0.0","joq62"}.


{passwd,"joq62","20Qazxsw20"}.

{deployment_spec,"math","1.0.0",no_restrictions,[{"adder_service","1.0.0"},{"divi_service","1.0.0"}]}.



