
require "pdf-reader"

def content_to_txt(filename=nil)
    file_name = "./Etablissements-reconnus-suite-2021.pdf"
    pdf  = PDF::Reader.new(file_name)

    puts pdf.page_count
    fork {exec("touch ./FirstPhase/#{file_name.chomp('.pdf')}.txt")} if !file_name

    output_file = File.open("./FirstPhase/#{file_name.chomp('.pdf')}.txt", 'w')
    pdf.pages.each_with_index do |page,i|
        index = 0
        page.text.each_line do |line|
            output_file.write(line) if index > 12 and !line.start_with?("Arrêté")
            index +=1
        end
        output_file.write("\n")
    end
    file.close
    puts "All Done FOr ThIs FiLe! Congratulation!"
end
header = ["REGION","PROVINCES","COMMUNE/ARRONDISSEMENT","VILLAGE/SECTEUR","NOM DE L'ETABLISSEMENT"]

def clean_file(input_file)
    outfile = "./SecondPhase/"+input_file.chomp(".txt")+"--2.txt"
    file = open(input_file, 'r')
    content = file.readlines
    output_file = open(outfile, "w")
    content.each do |line|
        line.lstrip!
        if line[0].to_i != 0
            
            p line[0].to_i
            output_file.write(line.lstrip)
        # rescue Exception =>error
        #     p error.message
        end
    end
    puts "ENd of the file here! "
end

# clean_file("./Etablissements-reconnus-suite-2021.txt")


def splitter(rows_file)

    file = open(rows_file, "r", :encoding=>"UTF-8")
    rows = file.readlines
    file.close
    # _test = "1 CENTRE OUEST        ZIRO          SAPOUY           SAPOUY              LYCEE PRIVE AÏCHA DE SAPOUY".encode("UTF-8")
    
    final = open(rows_file.chomp("--2.txt")+"--3.txt", "w")
    # p rows2
    
    rows.each do |row|
        sp = row.split("  ")
        nv = []
        t = ""
        sp.each do |entry|
            nv.append(entry.rstrip.lstrip)  unless entry.empty?
            txt = ""
            nv.each do |el|
                unless el.is_a?(NilClass)
                    if el.include?(" ")
                        el.gsub!(" ", "-")
                    end
                    txt += " " + el
                end
            end
            # final.write(entry) if entry.length >= 2
            t= txt
        end
        final.write(t)
        final.write("\n")
    end
    file.close
end

splitter("./SecondPhase/Etablissements-reconnus-suite-2021--2.txt")


def save_to_csv(filepath)
    ##############
    file = open(filepath, "r", :encoding=>"UTF-8")
    content = file.readlines
    file.close
    #############
    out = open(filepath.chomp("--3.txt")+".csv", "w")
    ###################
    content.each do |row|
        unless row.length < 5
            row.split.each_with_index do |entry, index|
                out.write(entry.gsub(/^\d+\-/, ""))
                # p index
                out.write(",") unless index+1 == row.split.length
            end
        end
        out.write("\n")
    end
    out.close
end

save_to_csv("SecondPhase/Etablissements-reconnus-suite-2021--3.txt")