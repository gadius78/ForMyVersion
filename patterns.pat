

PATTERN( p_seq_read )
@{
	xmain( xmax() );
	ymain( ymax() );
	dmain( 0x0 );
	count(1, amax() );
@}

%rd_loop1:
	xalu	xmain,xcare,cmeqmax,increment,dxmain,oxmain
	yalu	ymain,xcare,con,increment,dymain,oymain
	//datgen	sdmain, cntupdr, dmain, mainmain//, dbmwr
	datgen	mainmain
	chips	cs1pt,cs2pt,cs3f,cs4pt
	pinfunc	tset1, adhiz
	count	count1,decr,aon
	mar		cjmpnz,rd_loop1,read
%	mar	done

pattern(p_MBC1)
@{
	count(1, 31);
	count(2,15);
	count(3,3);
	dmain(0x00);
	dbase(0x01);

	dmain2(0x00);


@}
%write_func:
	mar gosub,write_init

%reset_func:
	mar gosub,reset_value

%read_func:
	mar gosub,read_init

%END:
mar done






%reset_value:

	datgen sudata, dmain, holddr
	udata 0x00
	mar return


%write_init:
		xalu xmain,xcare,coff,zero,dxmain,dxbase,oxmain
		yalu ymain,xcare,coff,zero,dymain,dybase,oymain
	
			%write_data:
				xalu oxmain
				yalu oymain
				datgen sdmain, dmain, cntupdr, mainmain,dbmwr
				//datgen base2base2
				chips cs1pt,cs2f,cs3pt,cs4pt // write mode
				pinfunc tset1
			
			%write_zero:
				xalu oxbase
				yalu oybase
				datgen basebase,dbmwr
				chips cs1pt,cs2f,cs3pt,cs4pt // write mode
				pinfunc tset1
		
			%move_y:
				yalu ymain,yudata,coff,add,dymain,oymain
				yudataval 0x01
				xalu oxmain	
				count count2,decr,aon
				mar cjmpnz,write_data
			

			%move_x:
				xalu xmain,xudata,coff,add,dxmain,oxmain
				xudataval 0x01
				yalu oymain	
				count count3,decr,aon
				mar cjmpnz,write_data

			%END_WRITE:
				mar return


%read_init:
		xalu xmain,xcare,coff,zero,dxmain,oxmain
		yalu ymain,xcare,coff,zero,dymain,oymain

	%read_data:
				xalu oxmain
				yalu oymain
				datgen sdmain, dmain, cntupdr, mainmain,dbmwr
			//	datgen main2main2
				chips cs1pt,cs2pt,cs3f,cs4pt //read mode
				pinfunc tset1,adhiz	
				mar read

	

		
			%move_y_r:
				yalu ymain,yudata,coff,add,dymain,oymain
				yudataval 0x01
				xalu oxmain	
				count count2,decr,aon
				mar cjmpnz,read_data
			

			%move_x_r:
				xalu xmain,xudata,coff,add,dxmain,oxmain
				xudataval 0x01
				yalu oymain	
				count count3,decr,aon
				mar cjmpnz,read_data
				
			%END_read:
				mar return
				
pattern(p_zigzag2)
@{
	
	
	count(4,ymax());
	count(5,xmax()/2);
	count(6,xmax());
	
	count(7,15);
	count(8,31);

	dmain(0x00); 
	dbase(amax()+2);
	
	
	
	
	xmain(xmax());
	ymain(ymax());

#define set_L_V 0x01 
#define set_max_v amax()
@}

		



%write_func:
	mar gosub,init_main

%reset_func:
	mar gosub, reset_value1

%reset_func2:
	mar gosub, reset_value2
	
%read_func:
	mar gosub,init_main_R

%reset_func3:
	mar gosub, reset_value3

%read_func2:
	mar gosub,init_main_R_2

%mar done





////////////////////////////Reset value Subroutine////////////////////////////////////////

%reset_value1:
	datgen sudata,dmain,holddr
				udata 0x00

//To calculate max value
%reset_value2:

	datgen sdbase, dbase, cntupdr
%reset_loop2:
			count count7,decr,aon
			mar cjmpnz,reset_value2


%reset_value3:
			datgen sudata,dmain,holddr
				udata 0x00

%mar return


//////////////////////////////////////////////////////////////////////////////////////////
	// Write Fucntion //
	// ============== //
	%init_main:
		xalu xmain,xcare,coff,zero,dxmain,dxbase,oxmain
		yalu ymain,xcare,coff,zero,dymain,dybase,oymain
	%init_base:
		xalu xbase,xcare,coff,comp,dxbase,oxbase 
		yalu ybase,xcare,coff,comp,dybase,oybase

			// yloop start(full yalu)
			%write_data_main:
				xalu oxmain
				yalu oymain
				datgen sdmain, dmain, cntupdr, mainmain

				chips cs1pt,cs2f,cs3pt,cs4pt // write mode
				pinfunc tset1


			%write_data_base:
				xalu oxbase
				yalu oybase
				datgen sdbase, dbase, cntdndr, basebase

				chips cs1pt,cs2f,cs3pt,cs4pt // write mode
				pinfunc tset1


		
			%write_move_main:
				yalu ymain,yudata,coff,add,dymain,oymain
				yudataval 0x01
				xalu oxmain	

			%write_move_base:
				yalu ybase,yudata,boff,subtract,dybase,oybase
				yudataval 0x01
				xalu oxbase
				count count4,decr,aon
				mar cjmpnz,write_data_main
			// yloop end

			%write_move_main2:
				xalu xmain,xudata,coff,add,dxmain,oxmain
				xudataval 0x01
				yalu oymain	

			%write_move_base2:
				xalu xbase,xudata,boff,subtract,dxbase,oxbase
				xudataval 0x01
				yalu oybase	
				count count6,decr,aon
				mar cjmpnz,write_data_main

%mar return
/////////////////////////////////////////////////////////////////////////////////////////
	// READ Fucntion //
	// ============== //
	%init_main_R:
		xalu xmain,xcare,coff,zero,dxmain,dxbase,oxmain
		yalu ymain,xcare,coff,zero,dymain,dybase,oymain
	%init_base_R:
		xalu xbase,xcare,coff,comp,dxbase,oxbase 
		yalu ybase,xcare,coff,comp,dybase,oybase

			// yloop start(full yalu)
			%read_data_main:
				xalu oxmain
				yalu oymain
				datgen sdmain, dmain, cntupdr, mainmain
				chips cs1pt,cs2pt,cs3f,cs4pt //read mode
				pinfunc tset1,adhiz
				mar read


			%read_data_base:
				xalu oxbase
				yalu oybase
				datgen sdbase, dbase, cntdndr, basebase
				chips cs1pt,cs2pt,cs3f,cs4pt //read mode
				pinfunc tset1,adhiz
				mar read


		
			%read_move_main:
				yalu ymain,yudata,coff,add,dymain,oymain
				yudataval 0x01
				xalu oxmain	

			%read_move_base:
				yalu ybase,yudata,boff,subtract,dybase,oybase
				yudataval 0x01
				xalu oxbase	
				count count4,decr,aon
				mar cjmpnz,read_data_main
			// yloop end

			%read_move_main2:
				xalu xmain,xudata,coff,add,dxmain,oxmain
				xudataval 0x01
				yalu oymain	

			%read_move_base2:
				xalu xbase,xudata,boff,subtract,dxbase,oxbase
				xudataval 0x01
				yalu oybase	
				count count5,decr,aon
				mar cjmpnz,read_data_main


%mar return 

/////////////////////////////////////////////////////////////////////////////////////////
	// READ Fucntion2 //
	// ============== //
	%init_main_R_2:
		xalu xmain,xcare,coff,zero,dxmain,oxmain
		yalu ymain,xcare,coff,zero,dymain,oymain
	
			// yloop start(full yalu)
			%read_data_main_2:
				xalu oxmain
				yalu oymain
				datgen sdmain, dmain, cntupdr, mainmain

				chips cs1pt,cs2pt,cs3f,cs4pt //read mode
				pinfunc tset1,adhiz
				mar read

		
			%read_move_main_2:
				yalu ymain,yudata,coff,add,dymain,oymain
				yudataval 0x01
				xalu oxmain	
				count count4,decr,aon
				mar cjmpnz,read_data_main_2
			// yloop end

			%read_move_main2_2:
				xalu xmain,xudata,coff,add,dxmain,oxmain
				xudataval 0x01
				yalu oymain	
				count count6,decr,aon
				mar cjmpnz,read_data_main_2


%mar return	

pattern(p_zigzag)
@{
	
	count(4,ymax());
	count(5,xmax()/2);
	count(6,xmax());
	
	count(7,7);
	count(8,15);

	dmain(0x00); 
	dbase(amax()+2);
	dbase2(0x77);
	dmain2(0x00);
	
	
	
	xmain(xmax());
	ymain(ymax());

#define set_L_V 0x01 
#define set_max_v amax()
@}

		

#if 0
	%write_zig:
		xalu xmain,xcare,cmeqmax,increment,dxmain,dxbase,oxmain
		yalu ymain,xcare,con,increment,dymain,dybase,oymain
		//datgen sdmain, dmain, cntupdr, mainmain,dbmwr
		chips cs1pt,cs2f,cs3pt,cs4pt // write mode
		pinfunc tset1
	

	%write_zag:
		xalu xbase,xcare,coff,hold,oxinv,dxbase,oxbase
		yalu ybase,xcare,coff,hold,oyinv,dybase,oybase
		//datgen sdbase, dbase, cntdndr, basebase,dbmwr
		chips cs1pt,cs2f,cs3pt,cs4pt // write mode
		pinfunc tset1	
		mar inc

	%count count3,decr,aon
	mar cjmpnz,write_zig

#endif






%write_func:
	mar gosub,init_write

%reset_value_func:
		mar gosub, reset_value1

%read_func:
	mar gosub,init_read

%reset_value_func2:
	mar gosub, reset_value1

%read_func2:
	mar gosub,init_read2

%mar done

	// Write Fucntion //
	// ============== //
	%init_write:
		xalu xmain,xcare,coff,zero,dxmain,oxmain
		yalu ymain,xcare,coff,zero,dymain,oymain
		

			// yloop start(full yalu)
			%write_data:
				xalu oxmain
				yalu oymain
				datgen sdmain, dmain, cntupdr, mainmain,dbmwr

				chips cs1pt,cs2f,cs3pt,cs4pt // write mode
				pinfunc tset1


			%write_d_inv:
				xalu xmain,xcare,coff,hold,oxinv,dxbase,oxbase
				yalu ymain,xcare,coff,hold,oyinv,dybase,oybase
				datgen sdbase, dbase, cntdndr, basebase,dbmwr
			
				chips cs1pt,cs2f,cs3pt,cs4pt // write mode
				pinfunc tset1

			%write_y_loop:
				yalu ymain,yudata,coff,add,dymain,oymain
				yudataval 0x01
				xalu oxmain	
				count count4,decr,aon
				mar cjmpnz,write_data
			// yloop end

			//xloop start(half xalu)
			%write_x_loop:
				xalu xmain,xcare,con,increment,dxmain,oxmain
				yalu oymain
				count count5,decr,aon
				mar cjmpnz,write_data


%mar return		



////////////////////////////Reset value Subroutine////////////////////////////////////////

%reset_value1:
			datgen sdmain, dmain, cntdndr
		%reset_loop1:
				count count7,decr,aon
				mar cjmpnz,reset_value1

%reset_value2:
			datgen sdbase, dbase, cntupdr
		%reset_loop2:
					count count7,decr,aon
					mar cjmpnz,reset_value2

%mar return


//////////////////////////////////////////////








	// Read Fucntion 1 //
	// working ZigZag //

	%init_read:
		xalu xmain,xcare,coff,zero,dxmain,dxbase,oxmain
		yalu ymain,xcare,coff,zero,dymain,dybase,oymain
		




			// yloop start(full yalu)
			%read_data1:
				xalu oxmain
				yalu oymain
		
				datgen sdmain, dmain, cntupdr, mainmain
		
				chips cs1pt,cs2pt,cs3f,cs4pt //read mode
				pinfunc tset1,adhiz
				mar read
				

			%read_a_inv:
				xalu xmain,xcare,coff,hold,dxbase
				yalu ymain,xcare,coff,hold,dybase

			%read_d_inv:
				xalu xbase,xcare,coff,hold,oxinv,dxbase,oxbase
				yalu ybase,xcare,coff,hold,oyinv,dybase,oybase
			
				datgen sdbase, dbase, cntdndr, basebase
		
				chips cs1pt,cs2pt,cs3f,cs4pt // read mode
				
				pinfunc tset1,adhiz
				mar read
			

			%read_a_noinv:
				yalu ymain,yudata,coff,add,dymain,oymain
				yudataval 0x01
				xalu oxmain	

			%read_y_loop:
				count count4,decr,aon
				mar cjmpnz,read_data1
			// yloop end

			//xloop start(half xalu)
			%read_x_loop:
				xalu xmain,xcare,con,increment,dxmain,oxmain
				yalu oymain
				count count5,decr,aon
				mar cjmpnz,read_data1

	%mar return		

	// Read Fucntion 2 //
	// working Sequential //
	%init_read2:
		xalu xmain,xcare,coff,zero,dxmain
		yalu ymain,xcare,coff,zero,dymain
		

			// yloop start(full yalu)
			%read_data_s:
				xalu oxmain
				yalu oymain
				
				datgen sdmain, dmain, cntupdr, mainmain		
				chips cs1pt,cs2pt,cs3f,cs4pt //read mode
				pinfunc tset1,adhiz
				mar read

			%read_y_loop2:
				yalu ymain,xcare,con,increment,dymain,oymain
				xalu xmain,xcare,cmeqmax,increment,dxmain,oxmain
				count count7,decr,aon
				mar cjmpnz,read_data_s
			// yloop end


			%xalu	xudata,xcare, coff, hold, dxmain, oxmain
			xudataval 0x1
			yalu	yudata,xcare, coff, hold, dymain, oymain
			yudataval 0x3

			
				%read_address_init_inv:
			xalu	xmain,xcare, coff, hold, dxbase
			yalu	ymain,xcare, coff, hold, dybase

			%read_loop_inv:
				xalu xbase,xcare,coff,oxinv,dxbase,oxbase
				yalu ybase,xcare,coff,oyinv,dybase,oybase
				chips	cs1pt,cs2pt,cs3f,cs4pt
				datgen sdmain, dmain, cntupdr, mainmain		
				pinfunc	tset1,adhiz
				mar read
			
			%read_loop_inv_cur:
			yalu ymain,xcare,bon,decrement,dymain,oymain
			xalu xmain,xcare,cbnemin,decrement,dxmain,oxmain
			count count7,decr,aon
			mar cjmpnz,read_address_init_inv



	%mar return		

PATTERN( p_stripes )
@{
	xmain(xmax());
	ymain(ymax()-1); ybase(0x01);

	dmain(0xFF); dbase(0x01);  //seq data value
	count(1,amax());
	count(2,xmax());
	count(3,((ymax()+1)/2)-1); //even and odds
@}

%write_loop_xall:
	xalu	xmain,xcare,con,increment,dxmain,oxmain
%write_loop_yodd:
	yalu ymain,ybase,con,add,dymain,oymain
	datgen sdmain,sdbase,add,dmain,mainmain,dbmwr
	chips	cs1pt,cs2f,cs3pt,cs4pt
	pinfunc tset1
	count count3,decr,aon
	mar cjmpnz, write_loop_yodd
%	count count2, decr, aon
	mar cjmpnz, write_loop_xall

% yalu ymain,xcare,con,increment,dymain

%write_loop_xall_even:
	xalu	xmain,xcare,con,increment,dxmain,oxmain
%write_loop_even:
	yalu ymain,ybase,con,add,dymain,oymain
	datgen sdmain,sdbase,add,dmain,mainmain,dbmwr
	chips	cs1pt,cs2f,cs3pt,cs4pt
	pinfunc tset1
	count count3,decr,aon
	mar cjmpnz, write_loop_even
%	count count2, decr, aon
	mar cjmpnz, write_loop_xall_even

% xalu xmain,xcare,con,increment,dxmain
yalu ymain,ybase,con,add,dymain
datgen  sdmain,sdbase,add,dmain


%read_loop_xall_even:
	xalu	xmain,xcare,bon,decrement,dxmain,oxmain
%read_loop_even:
	yalu	ymain,ybase,bon,subtract,dymain,oymain
	//datgen  basebase
	datgen  sdmain,sdbase,subtract,dmain,mainmain
	chips	cs1pt,cs2t,cs3pf,cs4pt
	pinfunc tset1,adhiz
	count count3,decr,aon
	mar cjmpnz, read_loop_even, read
%	count count2, decr, aon
	mar cjmpnz, read_loop_xall_even

% 	yalu ymain,xcare,bon,decrement,dymain

%read_loop_xall_odds:
	xalu	xmain,xcare,bon,decrement,dxmain,oxmain
%read_loop_odds:
	yalu	ymain,ybase,bon,subtract,dymain,oymain
	//datgen  basebase
	datgen  sdmain,sdbase,subtract,dmain,mainmain
	chips	cs1pt,cs2t,cs3pf,cs4pt
	pinfunc tset1,adhiz
	count count3,decr,aon
	mar cjmpnz, read_loop_odds, read
%	count count2, decr, aon
	mar cjmpnz, read_loop_xall_odds

%   mar     done
	pinfunc	adhiz


PATTERN( p_dbmtoecr )
	@{
	amain( amax());		// set both xmain and ymain to max value
	count(1, amax());	// pattern length
	dmain(0x00);			// data
	@}

%wr_loop: // add , manual increase , +2 loop 2time, read from end to start point
	xalu	xmain,xcare,con,increment,dxmain,oxmain
	yalu	ymain,xcare,cmeqmax,increment,dymain,oymain
	datgen	bufbuf
	chips	cs1pt,cs2f,cs3pt,cs4pt
	pinfunc	tset1
	count	count1,decr,aon
	mar		cjmpnz,wr_loop

%read_loop:
	xalu	xmain,xcare,con,increment,dxmain,oxmain
	yalu	ymain,xcare,cmeqmax,increment,dymain,oymain
	chips	cs1pt,cs2pt,cs3f,cs4pt
	datgen	mainmain
	pinfunc	tset1,adhiz
	count	count1,decr,aon
	mar		cjmpnz,read_loop,read

%   mar     done
	pinfunc	adhiz

//////////////////////////////////////////////////////////////////////
PATTERN( p_one_write )
	@{
	amain( amax());		// set both xmain and ymain to max value
	count(1, amax());	// pattern length
	dmain(0xFF);			// data
	@}

%wr_loop_init:
	xalu	xmain,xcare,con,increment,dxmain,oxmain
	yalu	ymain,xcare,cmeqmax,increment,dymain,oymain
	datgen	mainmain,dbmwr
	chips	cs1pt,cs2f,cs3pt,cs4pt
	pinfunc	tset1
	count	count1,decr,aon
	mar		cjmpnz,wr_loop_init

%   mar     done
	pinfunc	adhiz

//////////////////////////////////////////////////////////////////////
PATTERN( p_zero_write )
	@{
	amain( amax());		// set both xmain and ymain to max value
	count(1, amax());	// pattern length
	dmain(0x00);			// data
	@}

%wr_loop_init:
	xalu	xmain,xcare,con,increment,dxmain,oxmain
	yalu	ymain,xcare,cmeqmax,increment,dymain,oymain
	datgen	mainmain,dbmwr
	chips	cs1pt,cs2f,cs3pt,cs4pt
	pinfunc	tset1
	count	count1,decr,aon
	mar		cjmpnz,wr_loop_init

%   mar     done
	pinfunc	adhiz


PATTERN( p_wdvoh2 )
	@{
	amain( amax());		// set both xmain and ymain to max value
	xmain( 0);
	ymain( 0);
	count(1,1);
	dmain(0xff);
	@}

%wr_loop_init:
	xalu	xmain,xcare,xcare,xcare,dxmain,oxmain
	yalu	ymain,xcare,xcare,xcare,dymain,oymain
	datgen	mainmain,dbmwr
	chips	cs1pt,cs2f,cs3pt,cs4pt
	pinfunc	tset1
//	count	count1,decr,aon
	mar		jump,wr_loop_init
/*
%rd_loop:
	xalu	xmain,xcare,xcare,xcare,dxmain,oxmain
	yalu	ymain,xcare,xcare,xcare,dymain,oymain
	chips	cs1pt,cs2pt,cs3f,cs4pt
	pinfunc	tset1,adhiz
	count   count2, decr, aon
	mar		cjmpnz,rd_loop,read	*/

%   mar     done
	pinfunc	adhiz


PATTERN( p_wdvoh )
	@{
	amain( amax());		// set both xmain and ymain to max value
	xmain( 0);
	ymain( 0);
	count(1,1);
	dmain(0xff);
	@}

%wr_loop_init:
	xalu	xmain,xcare,xcare,xcare,dxmain,oxmain
	yalu	ymain,xcare,xcare,xcare,dymain,oymain
	datgen	mainmain,dbmwr
	chips	cs1pt,cs2f,cs3pt,cs4pt
	pinfunc	tset1
	count	count1,decr,aon
	mar		cjmpnz,wr_loop_init

%rd_loop:
	xalu	xmain,xcare,xcare,xcare,dxmain,oxmain
	yalu	ymain,xcare,xcare,xcare,dymain,oymain
	chips	cs1pt,cs2pt,cs3f,cs4pt
	pinfunc	tset1,adhiz
	mar		jump,rd_loop,read	

%   mar     done
	pinfunc	adhiz

PATTERN( p_wdvol )
	@{
	amain( amax());		// set both xmain and ymain to max value
	xmain( 0);
	ymain( 0);
	count(1,1);
	dmain(0x00);
	@}

%wr_loop_init:
	xalu	xmain,xcare,xcare,xcare,dxmain,oxmain
	yalu	ymain,xcare,xcare,xcare,dymain,oymain
	datgen	mainmain,dbmwr
	chips	cs1pt,cs2f,cs3pt,cs4pt
	pinfunc	tset1
	count	count1,decr,aon
	mar		cjmpnz,wr_loop_init

%rd_loop:
	xalu	xmain,xcare,xcare,xcare,dxmain,oxmain
	yalu	ymain,xcare,xcare,xcare,dymain,oymain
	chips	cs1pt,cs2pt,cs3f,cs4pt
	pinfunc	tset1
	mar		jump,rd_loop,read

%   mar     done
	pinfunc	adhiz

//////////////////////////////////////////////////////////////////////

PATTERN( p_readvolvoh )
	@{
	amain( amax());		// set both xmain and ymain to max value
	xmain( 0);
	ymain( 0);
	@}

%rd_loop:
	xalu	xmain,xcare,xcare,xcare,dxmain,oxmain
	yalu	ymain,xcare,xcare,xcare,dymain,oymain
	chips	cs1pt,cs2pt,cs3f,cs4pt
	pinfunc	tset1
	mar		jump,rd_loop,read

//////////////////////////////////////////////////////////////////////

PATTERN( p_idd_active )
	@{
	amain( amax());		// set both xmain and ymain to max value
	abase( 0);
	@}

%idd_loop:
	xalu	oxmain
	yalu	oymain
	chips	cs1t,cs2f,cs3pt,cs4t
	pinfunc	tset1
	mar		inc

%
	xalu	oxbase
	yalu	oybase
	chips	cs1t,cs2f,cs3pt,cs4t
	pinfunc	tset1
	mar		jump,idd_loop

%   mar     done
	pinfunc	adhiz
	// **** end of pattern ****

PATTERN( p_checkerboard )
	@{
	amain( amax());		// set both xmain and ymain to max value
	count(1, amax());	// pattern length
	dmain(0x0);			// data
	count(2, 1);
	@}

%wr_loop:
	xalu	xmain,xcare,con,increment,dxmain,oxmain
	yalu	ymain,xcare,cmeqmax,increment,dymain,oymain
	datgen	mainmain,bckfen,dbmwr
//	chips	cset1
	chips	cs1pt,cs2f,cs3pt,cs4pt
//	pinfunc	tset1,ps5
	pinfunc	tset1
%dummy_:
	count	count2, decr, aon
	mar		cjmpnz, dummy_

%	count	count1,decr,aon
	mar		cjmpnz, wr_loop

%rd_loop:
	xalu	xmain,xcare,con,increment,dxmain,oxmain
	yalu	ymain,xcare,cmeqmax,increment,dymain,oymain
	datgen	mainmain,bckfen
//	chips	cset2
	chips	cs1pt,cs2pt,cs3f,cs4pt
//	pinfunc	tset1, ps5, adhiz
	pinfunc	tset1, adhiz
	count	count1,decr,aon
	mar		cjmpnz,rd_loop,read

%wr_loop1:
	xalu	xmain,xcare,con,increment,dxmain,oxmain
	yalu	ymain,xcare,cmeqmax,increment,dymain,oymain
	datgen	mainmain,bckfen,dbmwr,invsns
//	chips	cset1
	chips	cs1pt,cs2f,cs3pt,cs4pt
//	pinfunc	tset1, ps5
	pinfunc	tset1
	
%dummy_1:
	count	count2, decr, aon
	mar		cjmpnz, dummy_1

%	count	count1,decr,aon
	mar		cjmpnz,wr_loop1

%rd_loop1:
	xalu	xmain,xcare,con,increment,dxmain,oxmain
	yalu	ymain,xcare,cmeqmax,increment,dymain,oymain
	datgen	mainmain,bckfen,invsns
//	chips	cset2
	chips	cs1pt,cs2pt,cs3f,cs4pt
//	pinfunc	tset1, ps5, adhiz
	pinfunc	tset1, adhiz
	count	count1,decr,aon
	mar		cjmpnz,rd_loop1,read


%   mar     done
	pinfunc	adhiz
	// **** end of pattern ****

PATTERN( p_diagonal )
	@{
	amain( amax());		// set both xmain and ymain to max value
	count(1, amax());	// pattern length
	dmain(0x00);			// data
	yindex(120);
	yindexmask(xmax());
	count(2,1);
	@}

%wr_loop_init:
	xalu	xmain,xcare,con,increment,dxmain,oxmain
	yalu	ymain,xcare,cmeqmax,increment,dymain,oymain
	datgen	mainmain,dbmwr
	chips	cs1pt,cs2f,cs3pt,cs4pt
	pinfunc	tset1
	count	count1,decr,aon
	mar		cjmpnz,wr_loop_init
	

%rd_loop_init:
	xalu	xmain,xcare,con,increment,dxmain,oxmain
	yalu	ymain,xcare,cmeqmax,increment,dymain,oymain
	datgen	mainmain
	chips	cs1pt,cs2pt,cs3f,cs4pt
	pinfunc	tset1, adhiz
	count	count1,decr,aon
	mar		cjmpnz,rd_loop_init

//////////////////////////////////////////////////////////////////
%wr_loop:
	xalu	xmain,xcare,con,increment,dxmain,oxmain
	yalu	ymain,xcare,cmeqmax,increment,dymain,oymain
	datgen	mainmain,xeqypn,dbmwr
	//datgen	mainmain,dbmwr
	chips	cs1pt,cs2f,cs3pt,cs4pt
	pinfunc	tset1
	count	count1,decr,aon
	mar		cjmpnz,wr_loop

%rd_loop:
	xalu	xmain,xcare,con,increment,dxmain,oxmain
	yalu	ymain,xcare,cmeqmax,increment,dymain,oymain
	datgen	mainmain,xeqypn
	//datgen	mainmain
	chips	cs1pt,cs2pt,cs3f,cs4pt
	pinfunc	tset1, adhiz
	count	count1,decr,aon
	mar		cjmpnz,rd_loop,read

%   mar     done
	pinfunc	adhiz
	// **** end of pattern ****



PATTERN( p_march )
	@{
	amain( amax());		// set both xmain and ymain to max value
	count(1, amax());	// pattern length
	dmain(0x0);			// data
	jamreg(0xff);
	count(2,2);
	@}

%wr_all_0s:	// write all zeros
	xalu	xmain,xcare,con,increment,dxmain,oxmain
	yalu	ymain,xcare,cmeqmax,increment,dymain,oymain
	datgen	mainmain,dbmwr
	chips	cs1pt,cs2f,cs3pt,cs4pt
	pinfunc	tset1
%dummy_1:
	count	count2, decr, aon
	mar		cjmpnz, dummy_1
%	count	count1,decr,aon
	mar		cjmpnz,wr_all_0s

%rd_1: // read a zero
	xalu	xmain,xcare,con,increment,dxmain,oxmain
	yalu	ymain,xcare,cmeqmax,increment,dymain,oymain
	datgen	mainmain
	chips	cs1pt,cs2pt,cs3f,cs4pt
	pinfunc	tset1, adhiz
	mar		inc, read

%	// write a one, hold address
	datgen	jamjam,dbmwr
	chips	cs1pt,cs2f,cs3pt,cs4pt
	pinfunc	tset1
	mar		inc

%dummy_2:
	count	count2, decr, aon
	mar		cjmpnz, dummy_2

%	// read a one, hold address
	datgen	jamjam
	chips	cs1pt,cs2pt,cs3f,cs4pt
	pinfunc	tset1,adhiz
	count	count1, decr, aon
	mar		cjmpnz,rd_1,read


%rd_all_1s:	// read all ones
	xalu	xmain,xcare,con,increment,dxmain,oxmain
	yalu	ymain,xcare,cmeqmax,increment,dymain,oymain
	datgen	jamjam
	chips	cs1pt,cs2pt,cs3f,cs4pt
	pinfunc	tset1
%dummy_3:
	count	count2, decr, aon
	mar		cjmpnz, dummy_3
%	count	count1,decr,aon
	mar		cjmpnz,rd_all_1s

%  	pinfunc	adhiz
	mar     done
 	// **** end of pattern ****




PATTERN( p_surround )
	@{
	amain( amax());		// set both xmain and ymain to max value
	count(1, amax());	// pattern length
	dmain(0x0);			// data
	jamreg(0xff);
	count(2,2);
	@}

%wr_all_0s:	// write all zeros
	xalu	xmain,xcare,con,increment,dxmain,oxmain
	yalu	ymain,xcare,cmeqmax,increment,dymain,oymain
	datgen	mainmain,dbmwr
	chips	cs1pt,cs2f,cs3pt,cs4pt
	pinfunc	tset1
%dummy_1:
	count	count2, decr, aon
	mar		cjmpnz, dummy_1
%	count	count1,decr,aon
	mar		cjmpnz,wr_all_0s

%rd_1:	// read a zero at reference location
	xalu	xmain,xcare,con,increment,dxmain,oxmain
	yalu	ymain,xcare,cmeqmax,increment,dymain,oymain
	datgen	mainmain
	chips	cs1pt,cs2pt,cs3f,cs4pt
	pinfunc	tset1, adhiz
	mar		inc, read

%	// write a one, hold address
	datgen	jamjam,dbmwr
	chips	cs1pt,cs2f,cs3pt,cs4pt
	pinfunc	tset1
%dummy_2:
	count	count2, decr, aon
	mar		cjmpnz, dummy_2
%	mar		inc

%	// read a one, hold address
	datgen	jamjam
	chips	cs1pt,cs2pt,cs3f,cs4pt
	pinfunc	tset1,adhiz
	mar		read

// check the 8 cells surrounding the reference location

%	// upper left cell
	xalu	xmain,xcare,bon,decrement,dxmain,oxmain
	yalu	ymain,xcare,bon,decrement,dymain,oymain
	datgen	mainmain
	chips	cs1pt,cs2pt,cs3f,cs4pt
	pinfunc	tset1,adhiz
	mar		read

%	// upper middle cell
	xalu	oxmain
	yalu	ymain,xcare,con,increment,dymain,oymain
	datgen	mainmain
	chips	cs1pt,cs2pt,cs3f,cs4pt
	pinfunc	tset1,adhiz
	mar		read

%	// upper right cell
	xalu	oxmain
	yalu	ymain,xcare,con,increment,dymain,oymain
	datgen	mainmain
	chips	cs1pt,cs2pt,cs3f,cs4pt
	pinfunc	tset1,adhiz
	mar		read

%	// middle right cell
	xalu	xmain,xcare,con,increment,dxmain,oxmain
	yalu	oymain
	datgen	mainmain
	chips	cs1pt,cs2pt,cs3f,cs4pt
	pinfunc	tset1,adhiz
	mar		read

%	// lower right cell
	xalu	xmain,xcare,con,increment,dxmain,oxmain
	yalu	oymain
	datgen	mainmain
	chips	cs1pt,cs2pt,cs3f,cs4pt
	pinfunc	tset1,adhiz
	mar		read

%	// lower middle cell
	xalu	oxmain
	yalu	ymain,xcare,bon,decrement,dymain,oymain
	datgen	mainmain
	chips	cs1pt,cs2pt,cs3f,cs4pt
	pinfunc	tset1,adhiz
	mar		read

%	// lower left cell
	xalu	oxmain
	yalu	ymain,xcare,bon,decrement,dymain,oymain
	datgen	mainmain
	chips	cs1pt,cs2pt,cs3f,cs4pt
	pinfunc	tset1,adhiz
	mar		read


%	// middle left cell
	xalu	xmain,xcare,bon,decrement,dxmain,oxmain
	yalu	oymain
	datgen	mainmain
	chips	cs1pt,cs2pt,cs3f,cs4pt
	pinfunc	tset1,adhiz
	mar		read

% //write the reference cell back to a zero
	xalu	oxmain
	yalu	ymain,xcare,con,increment,dymain,oymain
	datgen	mainmain,dbmwr
	chips	cs1pt,cs2f,cs3pt,cs4pt
	pinfunc	tset1
	count	count1, decr, aon
%dummy_3:
	count	count2, decr, aon
	mar		cjmpnz, dummy_3
%	mar		cjmpnz,rd_1


%  	pinfunc	adhiz
	mar     done
 	// **** end of pattern ****


PATTERN( p_symmetry)
@{
	xmain(xmax());
	ymain(ymax()); 
	ybase(0x01);

	dmain(0x00); //0x00
	dbase(0x01);
	dmain2(amax()+2);//0x41
	dbase2(0x01);
	count(1,((amax()+1)/2)-1);//32
	count(2,amax());//64
	count(3,255-(amax()+1)/2);//0xff-0x20 for upper data
	count(4,256); //0xff-0x21 
	output("amax() %d",amax());
	output("xmax() %d",xmax());
	output("ymax() %d",ymax());

@}


%init:
	xalu xmain, xcare, coff, zero, dxmain, dxbase, dxfield, oxmain
	yalu ymain, xcare, coff, zero, dymain, dybase, dyfield, oymain

%write_upper:
	yalu ymain,xcare,coff,hold,dymain,oymain
	xalu xmain,xcare,coff,hold,dxmain,oxmain
	datgen sdmain,sdbase,add,dmain,mainmain//,dbmwr
	chips	cs1pt,cs2f,cs3pt,cs4pt
	pinfunc tset1

%write_lower:
	xalu xmain,xcare,coff,oxinv,dxbase,oxbase
	yalu ymain,xcare,coff,oyinv,dybase,oybase
	datgen sdmain2,sdbase2,subtract,dmain2,main2main2//,dbmwr
	chips	cs1pt,cs2f,cs3pt,cs4pt
	pinfunc tset1
	
%pos_ctrl:
	yalu ymain,xcare,con,increment,dymain,oymain
	xalu xmain,xcare,cmeqmax,increment,dxmain,oxmain
	count   count1,decr,aon
	mar cjmpnz,write_upper
	
// sequencial read
%init2:
	xalu xmain, xcare, coff, zero, dxmain, dxbase, dxfield, oxmain
	yalu ymain, xcare, coff, zero, dymain, dybase, dyfield, oymain

%init3:
	datgen sdmain,sdbase,add
	count count3,decr,aon
	mar cjmpnz,init3

%read_loop_upper:
	yalu ymain,xcare,coff,hold,dymain,oymain
	xalu xmain,xcare,coff,hold,dxmain,oxmain
	chips	cs1pt,cs2pt,cs3f,cs4pt
	datgen	sdmain,sdbase,add,dmain,mainmain
	//datgen bufbuf
	pinfunc	tset1,adhiz
	mar read

%pos_ctrl2:
	yalu ymain,xcare,con,increment,dymain,oymain
	xalu xmain,xcare,cmeqmax,increment,dxmain,oxmain
	count count1,decr,aon
//	count count2,decr,aon
	mar cjmpnz,read_loop_upper

%init4:
	datgen sdmain2,sdbase2,subtract,dmain2,main2main2
	count count4,decr,aon
	mar cjmpnz,init4

%read_loop_lower:
	yalu ymain,xcare,coff,hold,dybase,oybase
	xalu xmain,xcare,coff,hold,dxbase,oxbase
	chips	cs1pt,cs2pt,cs3f,cs4pt
//	datgen	sdmain,sdbase,add,dmain,mainmain,dbmwr
	datgen	sdmain2,sdbase2,add,dmain2,main2main2,dbmwr
//	datgen bufbuf
	pinfunc	tset1,adhiz
	mar read

%pos_ctrl3:
	yalu ymain,xcare,con,increment,dymain,oymain
	xalu xmain,xcare,cmeqmax,increment,dxmain,oxmain
	count count1,decr,aon
	mar cjmpnz,read_loop_lower
	

%   mar     done
	pinfunc	adhiz
	

/*PATTERN( p_even_odd )
@{
	amain(amax());
	count(1, amax());
	count(2, 1);
	count(3, ymax()/2);
	count(4, xmax());
	dmain(0x00);
	dbase(0x01);
	dmain2(amax());
	dbase2(0x01);

#define _X_ADD	0x01
#define _Y_ADD	0x02
@}

%init:
	xalu xmain, xcare, coff, zero, dxmain, dxbase, dxfield, oxmain
	yalu ymain, xcare, coff, zero, dymain, dybase, dyfield, oymain	

%_write:
	xalu	xudata,xcare, coff, hold, dxfield, oxmain
	xudataval 0x0
	yalu	yudata,xcare, coff, hold, dyfield, oymain
	yudataval 0x1
	mar gosub,write_00
	
%_read:
	xalu	xudata,xcare, coff, hold, dxfield, oxmain
	xudataval 0x7	
	yalu	yudata,xcare, coff, hold, dyfield, oymain
	yudataval 0xe
	mar gosub,read_00
	
%   mar     done
	pinfunc	adhiz

%write_00:
	xalu	xfield, xcare, coff, hold, dxmain, oxmain
	yalu	yfield, xcare, coff, hold, dymain, oymain

%write_data:
	xalu	oxmain
	yalu	oymain
	datgen	mainmain, dbmwr
	chips	cs1pt,cs2f,cs3pt,cs4pt
	pinfunc	tset1

%write_y_even:	
	xalu	oxmain
	yalu	ymain, yudata, coff, add, dymain, oymain
	yudataval _Y_ADD
	datgen	sdmain,sdbase,add,dmain
	count	count3,decr,aon
	mar		cjmpnz,write_data
	
%write_y_odd:
	xalu	oxmain
	yalu	yudata,xcare, coff, hold, dymain, oymain
	yudataval 0x0
	count	count2,decr,aon // 2
	mar		cjmpnz,write_data
/*
%	datgen sudata, dmain
	udata 0x0
*/
/*
%write_x_inc:	
	xalu	xmain, xudata, coff, add, dxmain, oxmain
	xudataval _X_ADD
	yalu	yfield, xcare, coff, hold, dymain, oymain
	count	count4,decr,aon // xmax()
	mar		cjmpnz,write_data
	
% mar return

%read_00:
	xalu	xfield, xcare, coff, hold, dxmain, oxmain
	yalu	yfield, xcare, coff, hold, dymain, oymain

%read_data:
	xalu	oxmain
	yalu	oymain
	chips	cs1pt,cs2pt,cs3f,cs4pt
	datgen	main2main2//, invsns
	pinfunc	tset1,adhiz
	mar		read

%read_y_even:	
	xalu	oxmain
	yalu	ymain, yudata, boff, subtract, dymain
	//yalu	ymain, yudata, coff, add, dymain, oymain // forward read
	yudataval _Y_ADD
	datgen	sdmain2,sdbase2,subtract,dmain2,main2main2
	count	count3,decr,aon // ymax() / 2
	mar		cjmpnz,read_data

%read_y_odd:	
	xalu	oxmain
	yalu	yudata,xcare, coff, hold, dymain, oymain
	yudataval 0xf
	//yudataval 0x0 // forward read
	count	count2,decr,aon // 2
	mar		cjmpnz,read_data
	
%read_x_dec:	
	xalu	xmain, xudata, boff, subtract, dxmain
	//xalu	xmain, xudata, coff, add, dxmain, oxmain // forward read
	xudataval _X_ADD
	yalu	yfield, xcare, coff, hold, dymain, oymain
	count	count4,decr,aon // xmax()
	mar		cjmpnz,read_data
% mar return*/
