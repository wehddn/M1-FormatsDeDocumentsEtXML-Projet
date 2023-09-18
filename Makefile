all : python_conversion 1st_conversion 2nd_conversion 3rd_c_conversion 3rd_r_conversion

python_conversion :
	mkdir out
	cd src && python3 Conversion.py
	@echo "Done python"
	cd ..

1st_conversion :
	java -jar lib/saxon-he-10.3.jar -s:out/tree.xml -xsl:src/tree_1.xsl -o:out/tree2.xml
	@echo "Done 1st conversion"

2nd_conversion :
	java -jar lib/saxon-he-10.3.jar -s:out/tree2.xml -xsl:src/tree_2.xsl -o:out/tree3.xml
	@echo "Done 2nd conversion"

3rd_c_conversion :
	java -jar lib/saxon-he-10.3.jar -s:out/tree3.xml -xsl:src/tree_3r.xsl -o:out/res_r.svg
	@echo "Done 3rd circular conversion"

3rd_r_conversion :
	java -jar lib/saxon-he-10.3.jar -s:out/tree3.xml -xsl:src/tree_3c.xsl -o:out/res_c.svg
	@echo "Done 3rd rectangular conversion"

clean:
	rm -rf out