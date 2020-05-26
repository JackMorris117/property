require('pg')

class PropertyTracker

    attr_accessor :address, :value, :year_built, :build
    attr_reader :id

    def initialize(options)
        @id = options['id'].to_i if options['id']
        @address = options['@address']
        @value = options['@value'].to_i
        @year_built = options['year_built'].to_i
        @build = options['build']
    end

    def save()
        db = PG.connect( { dbname: 'properties', host:'localhost'} )
        sql = "INSERT INTO properties
            (address,
            value,
            year_built,
            build)
            VALUES
            ($1, $2, $3, $4)
            RETURNING *;"
        values = [@address, @value, @year_built, @build]
        db.prepare("save", sql)
        @id = db.exec_prepared("save", values)[0]["id"].to_i
        db.close()
    end

    def delete()
        db = PG.connect( { dbname: 'properties', host:'localhost'} )
        sql = "DELETE FROM properties WHERE id = $1" 
        values = [@id]
        db.prepare("delete_one", sql)
        db.exec_prepared("delete_one", values)
        db.close()
    end

    def PropertyTracker.delete_all()
        db = PG.connect( { dbname: 'properties', host:'localhost'} )
        sql = "DELETE FROM properties;"
        db.prepare("delete_all", sql)
        db.exec_prepared("delete_all")
        db.close()
    end

    def update()
        db = PG.connect( { dbname: 'properties', host:'localhost'} )
        sql = "UPDATE properties SET(address, value, year_built, build)
                =
                ($1, $2, $3, $4)
                WHERE id = $5"
        values = [@address, @value, @year_built, @build, @id]
        db.prepare("update", sql)
        db.exec_prepared("update", values)
        db.close()
    end
    
    def PropertyTracker.find()
        db = PG.connect(  { dbname: 'properties', host:'localhost'} )
        sql = "SELECT * FROM properties WHERE id = $1;"
        values = [@id]
        db.prepare("find", sql)
        tracker_properties = db.exec_prepared("find", values)
        db.close()
        return tracker_properties.map {|property| PropertyTracker.new(property)}
    end             

    def PropertyTracker.all()
        db = PG.connect(  { dbname: 'properties', host:'localhost'} )
        sql = "SELECT * FROM properties;"
        db.prepare("all", sql)
        tracker_properties = db.exec_prepared("all")
        db.close()
        return tracker_properties.map {|property| PropertyTracker.new(property)}
    end

end
